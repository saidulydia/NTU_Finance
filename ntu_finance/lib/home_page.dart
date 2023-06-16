import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntu_finance/plus_button.dart';
import 'package:ntu_finance/screens/login_page.dart';
import 'package:ntu_finance/top_card.dart';
import 'package:ntu_finance/transactions.dart';

class HoemPage extends StatefulWidget {
  const HoemPage({super.key});

  @override
  State<HoemPage> createState() => _HoemPageState();
}

class _HoemPageState extends State<HoemPage> {
  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  //https://www.youtube.com/watch?v=UeZ1bcEqEQE&t=2s&ab_channel=MitchKoko
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('NTU Expense'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () {
              signOutUser();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const LoginPage();
              }), (r) {
                return false;
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TopNeuCard(
              balance: "20,000",
              income: '200',
              expense: '30',
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      MyTransaction(
                        transactionName: 'Teaching',
                        money: '300',
                        expenseOrIncome: 'income',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            PlusButton(),
          ],
        ),
      ),
    );
  }
}
