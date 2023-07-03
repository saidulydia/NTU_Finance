import 'package:flutter/material.dart';
import 'package:ntu_finance/firebase/userPots.dart';
import 'package:ntu_finance/screens/create_saving_pot_page.dart';
import 'package:ntu_finance/screens/pot_list_page.dart';

class SavingsPotPage extends StatefulWidget {
  @override
  State<SavingsPotPage> createState() => _SavingsPotPageState();
}

class _SavingsPotPageState extends State<SavingsPotPage> {
  final User currentUser = User();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: currentUser.checkPotDocumentsExist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final bool potDocumentsExist = snapshot.data!;
          return potDocumentsExist ? PotsListPage() : CreateSavingsPotPage();
        }
      },
    );
  }
}
