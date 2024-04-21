import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_login/widgets/custom_button.dart';
import 'package:firebase_login/widgets/toast.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postcontroller = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add Post"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: postcontroller,
            decoration: InputDecoration(
              hintText: "Add  your thoughts",
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
                databaseRef
                    .child(id)
                    .set({'id': id, 'post': postcontroller.text.toString()})
                    .then((value) => postcontroller.clear())
                    // Toast().toastMessage("post added"),)
                    .onError(
                      (error, stackTrace) =>
                          Toast().toastMessage(error.toString()),
                    );
              },
              title: "Add")
        ],
      ),
    );
  }
}
