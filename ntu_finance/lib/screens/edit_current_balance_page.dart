import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCurrentAmountPage extends StatefulWidget {
  const EditCurrentAmountPage({Key? key}) : super(key: key);

  @override
  State<EditCurrentAmountPage> createState() => _EditCurrentAmountPageState();
}

class _EditCurrentAmountPageState extends State<EditCurrentAmountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: _buildTransactionsList(),
    );
  }

  Widget _buildTransactionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('accountBalance')
          .doc('FN6L6ht7KwCCNp2hAcJp')
          .collection('accountTransactions')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<QueryDocumentSnapshot> transactions = snapshot.data!.docs;
        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            Map<String, dynamic>? transactionData =
                transactions[index].data() as Map<String, dynamic>?;

            if (transactionData == null) {
              return Container(); // Handle the case when data is null
            }

            String dateString = transactionData['dateString'] ?? '';
            bool isAdding = transactionData['isAdding'] ?? false;

            return ExpansionTile(
              title: Text(dateString),
              children: [
                ListTile(
                  leading: Icon(
                    isAdding ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isAdding ? Colors.green : Colors.red,
                  ),
                  title: Text('Amount: ${transactionData['amount'] ?? ''}'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
