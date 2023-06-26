import 'package:flutter/material.dart';

class SavingsPotPage extends StatefulWidget {
  @override
  _SavingsPotPageState createState() => _SavingsPotPageState();
}

class _SavingsPotPageState extends State<SavingsPotPage> {
  String? potName;
  double? goalAmount;
  String? savingPeriod;
  DateTime? endDate;
  double? savingAmount;

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    savingPeriod = value;
                    _handleSavingPeriodChange(value);
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
                'End Date',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  _selectEndDate(context);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    hintText: 'Select the end date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    endDate != null
                        ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                        : 'Select the end date',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Create Pot'),
              ),
              const SizedBox(height: 16),
              if (savingAmount != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Estimated Saving Amount',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your estimated saving amount is: ${savingAmount!.toStringAsFixed(2)}',
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
    );
  }

  double calculateSavingAmount() {
    if (goalAmount == null || endDate == null) {
      return 0.0;
    }

    final daysRemaining = endDate!.difference(DateTime.now()).inDays;
    if (daysRemaining <= 0) {
      return 0.0;
    }

    if (savingPeriod == 'Weekly') {
      final weeksRemaining = (daysRemaining / 7).ceil();
      return goalAmount! / weeksRemaining;
    } else if (savingPeriod == 'Monthly') {
      final monthsRemaining = (endDate!.year - DateTime.now().year) * 12 +
          (endDate!.month - DateTime.now().month);
      return goalAmount! / monthsRemaining;
    }

    return 0.0;
  }

  void _handleSavingPeriodChange(String? value) {
    if (value == 'Weekly') {
      final minimumDate = DateTime.now().add(const Duration(days: 7));
      if (endDate != null && endDate!.isBefore(minimumDate)) {
        endDate = minimumDate;
      }
    } else if (value == 'Monthly') {
      final minimumDate = DateTime.now().add(const Duration(days: 30));
      if (endDate != null && endDate!.isBefore(minimumDate)) {
        endDate = minimumDate;
      }
    }
  }

  void _selectEndDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: _getMinimumDate(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        endDate = selectedDate;
      });
    }
  }

  DateTime _getMinimumDate() {
    if (savingPeriod == 'Weekly') {
      return DateTime.now().add(const Duration(days: 7));
    } else if (savingPeriod == 'Monthly') {
      return DateTime.now().add(const Duration(days: 30));
    }
    return DateTime.now();
  }
}
