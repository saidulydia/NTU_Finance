import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PotProgress {
  final String potDetailsCollection = 'potDetails';

  Future<String> getCurrentUserID() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String userId = auth.currentUser!.uid;
    return userId;
  }

  Future<double> getCurrentAmount(String potName) async {
    try {
      final String userID = await getCurrentUserID();
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      final DocumentReference userDocument = userCollection.doc(userID);

      final QuerySnapshot potQuerySnapshot = await userDocument
          .collection(potDetailsCollection)
          .where('potName', isEqualTo: potName)
          .limit(1)
          .get();

      if (potQuerySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot potDocumentSnapshot = potQuerySnapshot.docs[0];
        final Map<String, dynamic> potData =
            potDocumentSnapshot.data() as Map<String, dynamic>;
        final double currentAmount = potData['currentAmount'] as double;
        return currentAmount;
      }
    } catch (e) {
      debugPrint('Error retrieving current amount: $e');
    }

    return 0.0; // Return a default value if no amount is found or if there was an error
  }

  Future<void> addDateAmountEntry(
    String potName,
    String currentDate,
    double amount,
  ) async {
    try {
      final String userID = await getCurrentUserID();
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      final DocumentReference userDocument = userCollection.doc(userID);

      final QuerySnapshot potQuerySnapshot = await userDocument
          .collection(potDetailsCollection)
          .where('potName', isEqualTo: potName)
          .limit(1)
          .get();

      if (potQuerySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot potDocumentSnapshot = potQuerySnapshot.docs[0];
        final DocumentReference potDocument = potDocumentSnapshot.reference;

        // Create a new sub-collection for date and amount entries
        final CollectionReference dateAmountCollectionRef =
            potDocument.collection('dateAmountEntries');

        // Add a new document to the date and amount entries sub-collection
        await dateAmountCollectionRef.add({
          'date': currentDate,
          'amount': amount,
        });

        // Update the current amount in the pot document
        final Map<String, dynamic> potData =
            potDocumentSnapshot.data() as Map<String, dynamic>;
        final double currentAmount = potData['currentAmount'] as double;
        final double updatedAmount = currentAmount + amount;
        await potDocument.update({'currentAmount': updatedAmount});
      }
    } catch (e) {
      debugPrint('Error adding date and amount entry: $e');
    }
  }

  Future<List<DocumentSnapshot>> getAllSavingDetials(String docID) async {
    try {
      final String userID = await getCurrentUserID();
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference userDocument = userCollection.doc(userID);

      final QuerySnapshot potSnapshot = await userDocument
          .collection(potDetailsCollection)
          .doc(docID)
          .collection("dateAmountEntries")
          .get();

      return potSnapshot.docs;
    } catch (e) {
      debugPrint('Error retrieving pot documents: $e');
      return [];
    }
  }
}
