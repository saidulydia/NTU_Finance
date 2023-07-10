import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntu_finance/local_storage/local_storage.dart';
import 'package:ntu_finance/screens/login_page.dart';
import 'package:ntu_finance/screens/create_saving_pot_page.dart';
import 'package:ntu_finance/screens/savings_pot_page.dart';
import 'package:ntu_finance/top_card.dart';
import 'package:ntu_finance/widgets/category_cards.dart';

class HoemPage extends StatefulWidget {
  const HoemPage({Key? key}) : super(key: key);

  @override
  State<HoemPage> createState() => _HoemPageState();
}

class _HoemPageState extends State<HoemPage> {
  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  // https://www.youtube.com/watch?v=UeZ1bcEqEQE&t=2s&ab_channel=MitchKoko
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('NTU Expense'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const TopNeuCard(
                balance: "20,000",
                income: '200',
                expense: '30',
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
                          onTap: () {},
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle FAB tap here
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
