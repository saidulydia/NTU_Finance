import 'package:flutter/material.dart';

class SavingsPotPage extends StatefulWidget {
  @override
  _SavingsPotPageState createState() => _SavingsPotPageState();
}

class _SavingsPotPageState extends State<SavingsPotPage> {
  String? potName;
  double? goalAmount;
  String? savingPeriod;
  double? savingFrequency;
  double? savingAmount;
  int? frequencySliderValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Savings Pot'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name of the Pot',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    potName = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter the name of the pot',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Goal Amount',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    goalAmount = double.tryParse(value);
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter the goal amount',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Saving Period',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField(
                value: savingPeriod,
                onChanged: (value) {
                  setState(() {
                    savingPeriod = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Weekly',
                    child: Text('Weekly'),
                  ),
                  DropdownMenuItem(
                    value: 'Monthly',
                    child: Text('Monthly'),
                  ),
                ],
                decoration: InputDecoration(
                  hintText: 'Select the saving period',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Saving Frequency',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Slider(
                value: (frequencySliderValue ?? 0).toDouble(),
                min: 0,
                max: 30,
                divisions: 30,
                onChanged: (value) {
                  setState(() {
                    frequencySliderValue = value.toInt();
                    savingFrequency = value;
                  });
                },
              ),
              SizedBox(height: 8),
              Text(
                'Selected Saving Frequency: ${frequencySliderValue ?? 0}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Saving Amount',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your estimated saving amount is: ${calculateSavingAmount().toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
