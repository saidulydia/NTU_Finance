import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PotProgressPage extends StatefulWidget {
  final DocumentSnapshot<Object?> document;

  PotProgressPage({required this.document});

  @override
  State<PotProgressPage> createState() => _PotProgressPageState();
}

class _PotProgressPageState extends State<PotProgressPage> {
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _updateProgress();
  }

  void _updateProgress() {
    // Calculate the progress based on the current amount and goal amount
    double currentAmount = widget.document['currentAmount'].toDouble();
    double goalAmount = widget.document['goalAmount'].toDouble();
    setState(() {
      _currentProgress = currentAmount / goalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pot Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Name: ${widget.document['potName']}"),
            Text('Goal Amount: GBP ${widget.document['goalAmount']}'),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: _currentProgress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
                'Current Progress: ${(_currentProgress * 100).toStringAsFixed(2)}%'),
          ],
        ),
      ),
    );
  }
}
