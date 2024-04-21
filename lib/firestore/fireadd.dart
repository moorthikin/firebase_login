import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_login/widgets/custom_button.dart';
import 'package:firebase_login/widgets/toast.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titlecontroller = TextEditingController();
  final collectionref = FirebaseFirestore.instance.collection('Notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add Note"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: titlecontroller,
            decoration: InputDecoration(
              hintText: "Add  your Note",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          CustomButton(
              ontap: () {
                // for post the data to the database.
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                collectionref.doc(id).set({
                  'description': titlecontroller.text.toString(),
                  'id': id
                }).then((value) {
                  Toast().toastMessage("Notes added successfully");
                }).onError((error, stackTrace) {
                  Toast().toastMessage(error.toString());
                });
              },
              title: "Add")
        ],
      ),
    );
  }
}
