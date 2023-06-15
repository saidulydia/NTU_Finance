import 'dart:js_interop';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ntu_finance/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//227, 3, 88

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void signInWithEmailAndPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
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
