import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Reminder {
  final String title;
  final String description;
  final DateTime dateTime;

  Reminder(this.title, this.description, this.dateTime);
}

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminders"),
      ),
      body: _buildRemindersList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Create Reminder"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(
                            "${_selectedDateTime.toLocal()}".split(' ')[0],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addReminder();
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        label: const Text("Add Reminder"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRemindersList() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final userRef = _firestore.collection('users').doc(userId);

      return StreamBuilder<QuerySnapshot>(
        stream: userRef.collection('reminders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final reminderDocs = snapshot.data?.docs ?? [];
          final reminders = reminderDocs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Reminder(
              data['title'],
              data['description'],
              (data['dateTime'] as Timestamp).toDate(),
            );
          }).toList();

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              final formattedDateTime = DateFormat('MMM dd, yyyy - hh:mm a')
                  .format(reminder.dateTime);

              return ListTile(
                title: Text(reminder.title),
                subtitle: Text(
                  "${reminder.description}\n$formattedDateTime", // Use the formattedDateTime here
                ),
              );
            },
          );
        },
      );
    }

    return const Center(child: Text("Not logged in"));
  }

  Future<void> _addReminder() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null && _titleController.text.isNotEmpty) {
      final newReminder = Reminder(
        _titleController.text,
        _descriptionController.text,
        _selectedDateTime,
      );

      _titleController.clear();
      _descriptionController.clear();
      _selectedDateTime = DateTime.now();

      await _saveReminderToFirestore(newReminder);
    }
  }

  Future<void> _saveReminderToFirestore(Reminder reminder) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final userRef = _firestore.collection('users').doc(userId);

      final reminderData = {
        'title': reminder.title,
        'description': reminder.description,
        'dateTime': reminder.dateTime.toUtc(),
      };

      await userRef.collection('reminders').add(reminderData);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateTime) {
      setState(() {
        _selectedDateTime = picked;
      });
    }
  }
}
