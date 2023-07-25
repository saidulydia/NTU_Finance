import 'package:flutter/material.dart';
import 'package:ntu_finance/screens/edit_current_balance_page.dart';
import 'package:ntu_finance/top_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntu_finance/screens/login_page.dart';
import 'package:ntu_finance/screens/forex_page.dart';
import 'package:ntu_finance/widgets/category_cards.dart';
import 'package:ntu_finance/screens/savings_pot_page.dart';
import 'package:ntu_finance/local_storage/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  String _getCurrentBalanceFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? balanceData =
        snapshot.data() as Map<String, dynamic>?;
    double balance = balanceData?['currentAmount'] ?? 0;
    return balance.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('accountBalance')
          .doc('userAccountBalance')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('NTU Expense')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('NTU Expense')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        String balance = _getCurrentBalanceFromSnapshot(snapshot.data!);

        return Scaffold(
          appBar: AppBar(
            title: Text('NTU Expense'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () {
                  signOutUser();
                  LocalStorageManager().deleteUserId();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return const LoginPage();
                    }),
                    (r) => false,
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.grey[300],
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  TopNeuCard(
                    balance: balance,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditCurrentAmountPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CategoryCard(
                              icon: Icons.trending_up,
                              text: "Budget Tracking",
                              color: const Color(0xFF008080),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: CategoryCard(
                              icon: Icons.attach_money,
                              text: "Forex",
                              color: const Color(0xFFDDA0DD),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CurrencyConverterPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CategoryCard(
                              icon: Icons.account_balance_wallet,
                              text: "Manage Finance",
                              color: const Color(0xFF4682B4),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: CategoryCard(
                              icon: Icons.local_offer,
                              text: "Discounts",
                              color: const Color(0xFF556B2F),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CategoryCard(
                              icon: Icons.notification_important,
                              text: "Reminders",
                              color: const Color(0xFFFF7F50),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            child: CategoryCard(
                              icon: Icons.savings,
                              text: "Pot",
                              color: const Color(0xFFFF7F50),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SavingsPotPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
