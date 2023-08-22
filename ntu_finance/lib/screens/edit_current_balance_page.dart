import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ntu_finance/firebase/userBalance.dart';

class EditCurrentAmountPage extends StatefulWidget {
  const EditCurrentAmountPage({Key? key}) : super(key: key);

  @override
  State<EditCurrentAmountPage> createState() => _EditCurrentAmountPageState();
}

enum BudgetCategory {
  income,
  entertainment,
  shopping,
  food,
  utilities,
  others,
}

class _EditCurrentAmountPageState extends State<EditCurrentAmountPage> {
  double? _amount; // Variable to store the entered amount

  Future<void> _showAmountInputDialog() async {
    _amount = null; // Reset the amount variable

    BudgetCategory? selectedCategory =
        BudgetCategory.entertainment; // Default selected category

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // Declare a variable to store the selected action (add or remove)
        String selectedAction = 'add';

        return AlertDialog(
          title: const Text('Enter Amount'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text field for entering the amount
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _amount = double.tryParse(value);
                      });
                    },
                  ),
                  // Dropdown to select budget category
                  DropdownButton<BudgetCategory>(
                    value: selectedCategory,
                    onChanged: (BudgetCategory? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      }
                    },
                    items: BudgetCategory.values
                        .map<DropdownMenuItem<BudgetCategory>>(
                      (BudgetCategory category) {
                        return DropdownMenuItem<BudgetCategory>(
                          value: category,
                          child: Text(category
                              .toString()
                              .split('.')
                              .last), // Display enum value without the enum class name
                        );
                      },
                    ).toList(),
                  ),
                  // Radio buttons for selecting add or remove action
                  ListTile(
                    title: const Text('Add'),
                    leading: Radio(
                      value: 'add',
                      groupValue: selectedAction,
                      onChanged: (value) {
                        setState(() {
                          selectedAction = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Remove'),
                    leading: Radio(
                      value: 'remove',
                      groupValue: selectedAction,
                      onChanged: (value) {
                        setState(() {
                          selectedAction = value as String;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                // Call the appropriate method based on the selected action
                if (_amount != null) {
                  if (selectedAction == 'add') {
                    UserCurrentAccount().addToCurrentUserAmount(
                        _amount!,
                        getCurrentDate(),
                        selectedCategory.toString().split('.').last);
                  } else if (selectedAction == 'remove') {
                    UserCurrentAccount().removeFromCurrentUserAmount(
                        _amount!,
                        getCurrentDate(),
                        selectedCategory.toString().split('.').last);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  String getCurrentDate() {
    DateTime currentDate = DateTime.now();
    int year = currentDate.year;
    int month = currentDate.month;
    int day = currentDate.day;
    String date = "$day/$month/$year";
    return date;
  }

  String _getMonthYearFromDateString(String dateString) {
    List<String> dateParts = dateString
        .split('/'); // Split the date string into day, month, and year parts
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    DateTime date = DateTime(year, month, day);
    String monthName = DateFormat('MMMM').format(date);
    String formattedYear = DateFormat('y').format(date);
    return '$monthName $formattedYear';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: _buildTransactionsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAmountInputDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('accountTransactions')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<QueryDocumentSnapshot> transactions = snapshot.data!.docs;
        Map<String, List<QueryDocumentSnapshot>> transactionsByMonth = {};

        // Group transactions by month and year
        for (var transaction in transactions) {
          Map<String, dynamic>? transactionData =
              transaction.data() as Map<String, dynamic>?;

          if (transactionData == null) {
            continue; // Skip null data
          }

          String dateString = transactionData['dateString'] ?? '';
          String monthYear = _getMonthYearFromDateString(dateString);

          if (!transactionsByMonth.containsKey(monthYear)) {
            transactionsByMonth[monthYear] = [];
          }

          transactionsByMonth[monthYear]!.add(transaction);
        }

        return SingleChildScrollView(
          child: Column(
            children: transactionsByMonth.entries.map((entry) {
              String monthYear = entry.key;
              List<QueryDocumentSnapshot> transactionsForMonth = entry.value;

              return ExpansionTile(
                title: Text(monthYear), // Show the name of the month and year
                children: transactionsForMonth.map((transaction) {
                  Map<String, dynamic>? transactionData =
                      transaction.data() as Map<String, dynamic>?;

                  if (transactionData == null) {
                    return Container(); // Handle the case when data is null
                  }

                  String dateString = transactionData['dateString'] ?? '';
                  bool isAdding = transactionData['isAdding'] ?? false;

                  return ListTile(
                    leading: Icon(
                      isAdding ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isAdding ? Colors.green : Colors.red,
                    ),
                    title: Text('Amount: ${transactionData['amount'] ?? ''}'),
                    subtitle: Text(
                        'Category: ${transactionData['budgetCategory'] ?? ''}'),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
