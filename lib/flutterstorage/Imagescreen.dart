import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_login/widgets/custom_button.dart';
import 'package:firebase_login/widgets/toast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  File? _image;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("File is not picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Upload screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getImage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(border: Border.all()),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : Icon(Icons.image),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(
              ontap: () async {
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref("/images/" + "1234");

                firebase_storage.UploadTask upload =
                    ref.putFile(_image!.absolute);

                Future.value(upload).then((value) async {
                  var newUrl = await ref.getDownloadURL();
                  databaseRef.child("1234").set({
                    'post': newUrl.toString(),
                    'id': DateTime.now().microsecondsSinceEpoch.toString()
                  }).then((value) {
                    Toast().toastMessage("Image uploaded");
                  }).onError((error, stackTrace) {
                    Toast().toastMessage(error.toString());
                  });
                });
              },
              title: "Upload")
        ],
      ),
    );
  }
}
