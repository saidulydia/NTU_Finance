import 'package:flutter/material.dart';
import 'package:ntu_finance/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntu_finance/screens/login_page.dart';

//Credit to the code
//https://www.youtube.com/watch?v=_3W-JuIVFlg&t=301s&ab_channel=MitchKoko

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //User is logged in
            if (snapshot.hasData) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
            //User is not logged in
          }),
    );
  }
}
