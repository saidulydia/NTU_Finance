import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntu_finance/local_storage/local_storage.dart';

class UserProfilePage extends StatelessWidget {
  String profilePictureUrl = 'https://via.placeholder.com/150';
  String userName = 'username';
  String userEmail = 'user.name@example.com';

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    LocalStorageManager().deleteUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(profilePictureUrl),
            ),
            const SizedBox(height: 16.0),
            Text(
              userName,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              userEmail,
              style: const TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
