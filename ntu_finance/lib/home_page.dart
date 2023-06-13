import 'package:flutter/material.dart';

import 'authentication.dart';

class HoemPage extends StatefulWidget {
  const HoemPage({super.key});

  @override
  State<HoemPage> createState() => _HoemPageState();
}

class _HoemPageState extends State<HoemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home Page"),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Auth().signOut();
                  Navigator.pop(context);
                },
                child: const Text("Sign Out"))
          ],
        ),
      ),
    );
  }
}
