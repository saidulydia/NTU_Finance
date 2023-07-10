import 'package:ntu_finance/firebase/potProgress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PotProgressPage extends StatefulWidget {
  final DocumentSnapshot<Object?> document;

  PotProgressPage({super.key, required this.document});

  @override
  State<PotProgressPage> createState() => _PotProgressPageState();
}

class _PotProgressPageState extends State<PotProgressPage> {
  double _currentProgress = 0.0;
  double? _amount; // Variable to store the entered amount

  @override
  void initState() {
    super.initState();
    _updateProgress();
  }

  void _updateProgress() async {
    // Calculate the progress based on the current amount and goal amount
    double currentAmount = widget.document['currentAmount'].toDouble();
    double goalAmount = widget.document['goalAmount'].toDouble();
    setState(() {
      _currentProgress = currentAmount / goalAmount;
    });
  }

  String getCurrentDate() {
    DateTime currentDate = DateTime.now();
    int year = currentDate.year;
    int month = currentDate.month;
    int day = currentDate.day;
    String date = "$day/$month/$year";
    return date;
  }

  Future<void> _showAmountInputDialog() async {
    _amount = null; // Reset the amount variable

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
                    PotProgress().addDateAmountEntry(
                      widget.document['potName'],
                      getCurrentDate(),
                      _amount!,
                      true,
                    );
                  } else if (selectedAction == 'remove') {
                    PotProgress().removeDateAmountEntry(
                      widget.document['potName'],
                      getCurrentDate(),
                      _amount!,
                      false,
                    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pot Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAmountInputDialog();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${widget.document['potName']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Goal Amount: GBP ${widget.document['goalAmount']}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LinearProgressIndicator(
              value: _currentProgress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Current Progress: ${(_currentProgress * 100).toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    PotProgress().getSavingDetailsStream(widget.document.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final List<DocumentSnapshot> potDocuments =
                        snapshot.data!.docs;
                    if (potDocuments.isEmpty) {
                      return const Center(
                        child: Text('Start Saving!'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: potDocuments.length,
                        itemBuilder: (context, index) {
                          final document = potDocuments[index];
                          return Card(
                            color: Colors.white,
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              title: Text(
                                "Amount: GBP ${document['amount']}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                'Date: ${document['date']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              leading: const Icon(
                                Icons.money,
                                size: 32,
                                color: Colors.blue,
                              ),
                              trailing: Icon(
                                document['isAdding']
                                    ? Icons.arrow_upward
                                    : Icons.remove,
                                size: 32,
                                color: document['isAdding']
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
