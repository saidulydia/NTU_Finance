import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class BudgetCategoryData {
  final String category;
  final double amount;

  BudgetCategoryData(this.category, this.amount);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BudgetChartPage(),
    );
  }
}

class BudgetChartPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BudgetCategoryData>> _fetchBudgetData() async {
    final currentUser = _auth.currentUser;
    final data = await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('accountTransactions')
        .get();

    Map<String, double> categorySumMap = {};

    for (var doc in data.docs) {
      final isAdding = doc['isAdding'] as bool;

      if (isAdding == false) {
        final category = doc['budgetCategory'] as String;
        final amount = doc['amount'] as double;

        categorySumMap.update(category, (value) => value + amount,
            ifAbsent: () => amount);
      }
    }

    return categorySumMap.entries
        .map((entry) => BudgetCategoryData(entry.key, entry.value))
        .toList();
  }

  List<Color> generateSectionColors(int count) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.yellow,
    ];

    // Repeat the colors if there are more sections than available colors
    while (colors.length < count) {
      colors.addAll(colors);
    }

    return colors.sublist(0, count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgeting'),
      ),
      body: FutureBuilder<List<BudgetCategoryData>>(
        future: _fetchBudgetData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          final data = snapshot.data!;
          List<Color> sectionColors = generateSectionColors(data.length);

          return Column(
            children: [
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final budget = entry.value;
                      return PieChartSectionData(
                        value: budget.amount,
                        title: budget.category,
                        titleStyle: const TextStyle(fontSize: 14),
                        color: sectionColors[index],
                      );
                    }).toList(),
                    sectionsSpace: 4,
                    centerSpaceRadius: 50,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final budget = data[index];
                    return ListTile(
                      title: Text(budget.category.toUpperCase()),
                      subtitle:
                          Text('Amount: ${budget.amount.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
