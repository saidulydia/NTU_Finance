import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String potDetailsCollection = 'potDetails';

  Future<String> getCurrentUserID() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userId = auth.currentUser!.uid;
    return userId;
  }

  Future<void> setCurrentUserData(String potName, double currentAmount,
      double goalAmount, String savingPeriod, int savingFrequency) async {
    try {
      final String userID = await getCurrentUserID();
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      final DocumentReference userDocument = userCollection.doc(userID);

      // Set pot details
      final DocumentReference potDocument =
          userDocument.collection(potDetailsCollection).doc();
      await potDocument.set({
        'potName': potName,
        'currentAmount': currentAmount,
        'goalAmount': goalAmount,
        'savingPeriod': savingPeriod,
        'savingFrequency': savingFrequency,
      });
    } catch (e) {
      print('Error setting current user data: $e');
    }
  }

  Future<bool> checkPotDocumentsExist() async {
    try {
      final String userID = await getCurrentUserID();
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference userDocument = userCollection.doc(userID);

      final QuerySnapshot potSnapshot =
          await userDocument.collection(potDetailsCollection).limit(1).get();

      return potSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking pot documents existence: $e');
      return false;
    }
  }

  Future<List<DocumentSnapshot>> getAllPotDocuments() async {
    try {
      final String userID = await getCurrentUserID();
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference userDocument = userCollection.doc(userID);

      final QuerySnapshot potSnapshot =
          await userDocument.collection(potDetailsCollection).get();

      return potSnapshot.docs;
    } catch (e) {
      print('Error retrieving pot documents: $e');
      return [];
    }
  }

  Future<void> deletePotDocument(String potId) async {
    try {
      final String userID = await getCurrentUserID();
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference userDocument = userCollection.doc(userID);

      final DocumentReference potDocument =
          userDocument.collection(potDetailsCollection).doc(potId);
      await potDocument.delete();
    } catch (e) {
      print('Error deleting pot document: $e');
    }
  }
}
