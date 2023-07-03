import 'package:ntu_finance/screens/create_saving_pot_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntu_finance/firebase/userPots.dart';
import 'package:flutter/material.dart';

class PotsListPage extends StatelessWidget {
  final User currentUser = User();

  PotsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pots'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: currentUser.getAllPotDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<DocumentSnapshot<Object?>> potDocuments = snapshot.data!;
            if (potDocuments.isEmpty) {
              return const Center(
                child: Text('No Pot Documents'),
              );
            } else {
              return ListView.builder(
                itemCount: potDocuments.length,
                itemBuilder: (context, index) {
                  final document = potDocuments[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Dismissible(
                      key: Key(document.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        final potId = document.id;
                        await User().deletePotDocument(potId);
                      },
                      child: ListTile(
                        title: Text("Name: " + document['potName']),
                        subtitle:
                            Text('Goal Amount: GBP ${document['goalAmount']}'),
                        leading: Icon(Icons.savings),
                        trailing: Icon(Icons.arrow_forward),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateSavingsPotPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
