import 'package:flutter/material.dart';

class FinancialTip {
  final String title;
  final String description;
  final String? website;

  FinancialTip(this.title, this.description, this.website);
}

class ManageFinancePage extends StatefulWidget {
  @override
  _ManageFinancePageState createState() => _ManageFinancePageState();
}

class _ManageFinancePageState extends State<ManageFinancePage> {
  final List<FinancialTip> _tips = [
    FinancialTip(
      "Create a Budget",
      "Start by creating a budget to track your income and expenses. This will help you manage your money more effectively.",
      null,
    ),
    FinancialTip(
      "Save Regularly",
      "Set up an automatic savings plan to ensure you save a portion of your income regularly. Even small amounts can add up over time.",
      null,
    ),
    FinancialTip(
      "Avoid High-Interest Debt",
      "Be cautious with credit cards and loans. Avoid high-interest debt that can quickly accumulate and become difficult to pay off.",
      null,
    ),
    FinancialTip(
      "Cook at Home",
      "Eating out can be expensive. Try cooking at home more often to save money on food and also improve your cooking skills.",
      null,
    ),
    FinancialTip(
      "Use Student Discounts",
      "Take advantage of student discounts on various products and services. Many businesses offer special rates for students.",
      null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Financial Tips for Students"),
      ),
      body: ListView.builder(
        itemCount: _tips.length,
        itemBuilder: (context, index) {
          return FinancialTipCard(_tips[index]);
        },
      ),
    );
  }
}

class FinancialTipCard extends StatelessWidget {
  final FinancialTip tip;

  FinancialTipCard(this.tip);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tip.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(tip.description),
            SizedBox(height: 12),
            if (tip.website != null)
              ElevatedButton(
                onPressed: () {
                  // Open the website link
                },
                child: Text("Learn More"),
              ),
          ],
        ),
      ),
    );
  }
}
