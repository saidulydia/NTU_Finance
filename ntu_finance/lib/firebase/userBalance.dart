import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCurrentAccount {
  // Reference to the Firestore collection
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Method to set the current user's amount in the accountBalance subcollection
  Future<void> setCurrentUserAmount(double currentAmount) async {
    try {
      // Get the current user's ID
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Get the reference to the accountBalance subcollection for the current user
      CollectionReference accountBalanceCollection =
          usersCollection.doc(currentUserId).collection('accountBalance');

      // Create a new document in the accountBalance subcollection with the current amount
      await accountBalanceCollection.add({
        'currentAmount': currentAmount,
      });
    } catch (e) {
      // Handle errors here if necessary
      debugPrint("Error updating current amount: $e");
    }
  }

// Method to add the new amount and transaction details
  Future<void> addToCurrentUserAmount(double amount, String dateString) async {
    try {
      // Get the current user's ID
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Get the reference to the accountBalance subcollection for the current user
      CollectionReference accountBalanceCollection =
          usersCollection.doc(currentUserId).collection('accountBalance');

      // Use a fixed document ID to represent the user's account balance
      String accountBalanceDocumentId = 'userAccountBalance';

      // Fetch the current data from the accountBalance subcollection
      DocumentSnapshot accountBalanceSnapshot =
          await accountBalanceCollection.doc(accountBalanceDocumentId).get();

      // Get the current amount from the snapshot data
      Map<String, dynamic>? accountBalanceData =
          accountBalanceSnapshot.data() as Map<String, dynamic>?;
      double currentAmount = accountBalanceData?['currentAmount'] ?? 0;

      // Add the new amount to the current amount
      double updatedAmount = currentAmount + amount;

      // Update the amount and date in the accountBalance subcollection
      await accountBalanceCollection.doc(accountBalanceDocumentId).set({
        'currentAmount': updatedAmount,
        'dateString': dateString,
      }, SetOptions(merge: true));

      // Update the transaction details in the accountTransactions subcollection
      CollectionReference accountTransactionsCollection =
          usersCollection.doc(currentUserId).collection('accountTransactions');
      await accountTransactionsCollection.add({
        'amount': amount,
        'dateString': dateString,
        'isAdding': true,
      });
    } catch (e) {
      // Handle errors here if necessary
      debugPrint("Error updating current amount: $e");
    }
  }

// Method to add the new amount and transaction details
  Future<void> removeFromCurrentUserAmount(
      double amount, String dateString) async {
    try {
      // Get the current user's ID
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Get the reference to the accountBalance subcollection for the current user
      CollectionReference accountBalanceCollection =
          usersCollection.doc(currentUserId).collection('accountBalance');

      // Use a fixed document ID to represent the user's account balance
      String accountBalanceDocumentId = 'userAccountBalance';

      // Fetch the current data from the accountBalance subcollection
      DocumentSnapshot accountBalanceSnapshot =
          await accountBalanceCollection.doc(accountBalanceDocumentId).get();

      // Get the current amount from the snapshot data
      Map<String, dynamic>? accountBalanceData =
          accountBalanceSnapshot.data() as Map<String, dynamic>?;
      double currentAmount = accountBalanceData?['currentAmount'] ?? 0;

      // Add the new amount to the current amount
      double updatedAmount = currentAmount - amount;

      // Update the amount and date in the accountBalance subcollection
      await accountBalanceCollection.doc(accountBalanceDocumentId).set({
        'currentAmount': updatedAmount,
        'dateString': dateString,
      }, SetOptions(merge: false));

      // Update the transaction details in the accountTransactions subcollection
      CollectionReference accountTransactionsCollection =
          usersCollection.doc(currentUserId).collection('accountTransactions');
      await accountTransactionsCollection.add({
        'amount': amount,
        'dateString': dateString,
        'isAdding': true,
      });
    } catch (e) {
      // Handle errors here if necessary
      debugPrint("Error updating current amount: $e");
    }
  }
}
