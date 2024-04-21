import 'dart:io';

import 'package:firebase_login/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  File? _image;
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
          CustomButton(ontap: () {}, title: "Upload")
        ],
      ),
    );
  }
}
