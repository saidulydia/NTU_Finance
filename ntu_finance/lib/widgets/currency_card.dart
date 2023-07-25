import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String currency;
  final double rate;

  CurrencyCard({required this.currency, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Adjust the elevation as per your preference
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'USD/$currency',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // Add some spacing between the texts
            Text(
              '\$${rate.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
