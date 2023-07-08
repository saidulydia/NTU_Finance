import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ntu_finance/firebase/userPots.dart';
import 'package:ntu_finance/home_page.dart';

class CreateSavingsPotPage extends StatefulWidget {
  @override
  _CreateSavingsPotPageState createState() => _CreateSavingsPotPageState();
}

class _CreateSavingsPotPageState extends State<CreateSavingsPotPage> {
  String? potName;
  double? goalAmount;
  String? savingPeriod;
  int? savingFrequency;
  double? savingAmount;
  int? frequencySliderValue;
  List<List<dynamic>> empty2DArray = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Savings Pot'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name of the Pot',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    potName = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter the name of the pot',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Goal Amount',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    goalAmount = double.tryParse(value);
                  });
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter the goal amount',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Saving Period',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: savingPeriod,
                onChanged: (value) {
                  setState(() {
                    savingPeriod = value as String?;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: 'Weekly',
                    child: Text('Weekly'),
                  ),
                  DropdownMenuItem(
                    value: 'Monthly',
                    child: Text('Monthly'),
                  ),
                ],
                decoration: const InputDecoration(
                  hintText: 'Select the saving period',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Saving Frequency',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Slider(
                value: frequencySliderValue?.toDouble() ?? 0,
                min: 0,
                max: 30,
                divisions: 30,
                onChanged: (value) {
                  setState(() {
                    frequencySliderValue = value.round();
                    savingFrequency = frequencySliderValue;
                  });
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Selected Saving Frequency: ${frequencySliderValue ?? 0}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimated Saving Amount',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your estimated saving amount is: ${calculateSavingAmount().toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle FAB tap here
          User().setCurrentUserData(
            potName!,
            0,
            goalAmount!,
            savingPeriod!,
            savingFrequency!,
          );
          Fluttertoast.showToast(
            msg: "Pot Created",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
          );
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const HoemPage();
          }), (r) {
            return false;
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  double calculateSavingAmount() {
    if (goalAmount == null || savingFrequency == null) {
      return 0.0;
    }
    if (savingPeriod == 'Weekly') {
      return goalAmount! / (savingFrequency! * 4.33);
    } else if (savingPeriod == 'Monthly') {
      return goalAmount! / savingFrequency!;
    }
    return 0.0;
  }
}
