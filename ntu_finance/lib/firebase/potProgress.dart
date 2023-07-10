import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ntu_finance/local_storage/local_storage.dart';

class PotProgress {
  final String potDetailsCollection = 'potDetails';

  String? userID = LocalStorageManager().getUserId();

  Future<double> getCurrentAmount(String potName) async {
    try {
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

    return 0.0;
  }

  Future<void> addDateAmountEntry(
    String potName,
    String currentDate,
    double amount,
    bool isAdding,
  ) async {
    try {
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
          'isAdding': isAdding,
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

  Future<List<Map<String, dynamic>>> getCurrentPotDetails(String docID) async {
    try {
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference userDocument = userCollection.doc(userID);

      final QuerySnapshot potSnapshot =
          await userDocument.collection(potDetailsCollection).get();

      List<Map<String, dynamic>> potDetailsList = [];

      for (DocumentSnapshot document in potSnapshot.docs) {
        if (document.id == docID) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          int goalAmount = data['goalAmount'] as int;
          int currentAmount = data['currentAmount'] as int;

          Map<String, dynamic> potDetails = {
            'docID': document.id,
            'goalAmount': goalAmount,
            'currentAmount': currentAmount,
          };

          potDetailsList.add(potDetails);
        }
      }

      return potDetailsList;
    } catch (e) {
      debugPrint('Error retrieving pot documents: $e');
      return [];
    }
  }

  //This method is for when the user is removing an amount from the storage
  void removeDateAmountEntry(
    String potName,
    String currentDate,
    double amount,
    bool isAdding,
  ) async {
    try {
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
          'isAdding': isAdding,
        });

        // Update the current amount in the pot document
        final Map<String, dynamic> potData =
            potDocumentSnapshot.data() as Map<String, dynamic>;
        final double currentAmount = potData['currentAmount'] as double;
        final double updatedAmount = currentAmount - amount;
        await potDocument.update({'currentAmount': updatedAmount});
      }
    } catch (e) {
      debugPrint('Error adding date and amount entry: $e');
    }
  }

  Stream<QuerySnapshot> getSavingDetailsStream(String potId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .collection(potDetailsCollection)
        .doc(potId)
        .collection("dateAmountEntries")
        .snapshots();
  }
}
