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

          return Column(
            children: [
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: data.map((budget) {
                      return PieChartSectionData(
                        value: budget.amount,
                        title: budget.category,
                        titleStyle: const TextStyle(fontSize: 14),
                        // badgeWidget: Column(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Text(
                        //       '${budget.amount.toStringAsFixed(2)}',
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold,
                        //         color: const Color(0xff000000),
                        //       ),
                        //     ),
                        //     Text(
                        //       'Amount',
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         color: const Color(0xff878787),
                        //       ),
                        //     ),
                        //   ],
                        // ),
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
