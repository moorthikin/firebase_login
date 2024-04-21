import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_login/firestore/fireadd.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final collectionRef =
      FirebaseFirestore.instance.collection('Notes').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('Notes');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post screen"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: collectionRef,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              Center(
                child: Text("Some thing went worng"),
              );
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // ref
                      //     .doc(snapshot.data!.docs[index]['id'])
                      //     .update({'description': "I am a flutter developer!"});

                      ref.doc(snapshot.data!.docs[index]['id']).delete();
                    },
                    title: Text(snapshot.data!.docs[index]['description']),
                    subtitle: Text(snapshot.data!.docs[index]['id']),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNote()));
        },
        child: Text("Add"),
      ),
    );
  }
}
