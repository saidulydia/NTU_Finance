import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntu_finance/home_page.dart';

import '../authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//227, 3, 88

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Future<bool> signInWithEmailAndPassword() async {
  //   try {
  //     debugPrint(_emailController.text);
  //     debugPrint(_passwordController.text);
  //     Auth().signInWithEmailAndPassword(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //     );
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  void signInWithEmailAndPassword() async {
    _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HoemPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(227, 3, 88, 0.9),
        title: const Center(
            child: Text(
          "My Finance",
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                controller: _emailController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                )),
            const SizedBox(
              height: 20,
            ),
            TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                )),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton(
                child: const Text(
                  "Login",
                  style: TextStyle(color: Color.fromRGBO(227, 3, 88, 0.9)),
                ),
                onPressed: () async {
                  signInWithEmailAndPassword();
                }),
          ],
        ),
      ),
    );
  }
}
