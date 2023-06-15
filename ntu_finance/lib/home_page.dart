import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntu_finance/screens/login_page.dart';

class HoemPage extends StatefulWidget {
  const HoemPage({super.key});

  @override
  State<HoemPage> createState() => _HoemPageState();
}

class _HoemPageState extends State<HoemPage> {
  void signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home Page"),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  signOutUser();
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const LoginPage();
                  }), (r) {
                    return false;
                  });
                },
                child: const Text("Sign Out"))
          ],
        ),
      ),
    );
  }
}
