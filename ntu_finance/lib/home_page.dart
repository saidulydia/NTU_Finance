import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authentication.dart';

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
                  Navigator.pop(context);
                },
                child: const Text("Sign Out"))
          ],
        ),
      ),
    );
  }
}
