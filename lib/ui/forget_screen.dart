import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/widgets/custom_button.dart';
import 'package:firebase_login/widgets/toast.dart';
import 'package:flutter/material.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final auth = FirebaseAuth.instance;

  final emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: emailcontroller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Enter your mail"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(
              ontap: () {
                auth
                    .sendPasswordResetEmail(
                        email: emailcontroller.text.toString())
                    .then((value) =>
                        Toast().toastMessage("Mail send to the Email"))
                    .onError((error, stackTrace) {
                  Toast().toastMessage(error.toString());
                });
              },
              title: "Send code")
        ],
      ),
    );
  }
}
