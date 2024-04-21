import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/ui/verify.dart';
import 'package:firebase_login/widgets/custom_button.dart';
import 'package:firebase_login/widgets/toast.dart';
import 'package:flutter/material.dart';

class PhoneSignup extends StatefulWidget {
  const PhoneSignup({super.key});

  @override
  State<PhoneSignup> createState() => _PhoneSignupState();
}

class _PhoneSignupState extends State<PhoneSignup> {
  final phoneNumber = TextEditingController(text: "+91");

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Phone number"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneNumber,
              decoration: InputDecoration(
                hintText: "+91 9361389082",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          CustomButton(
              ontap: () {
                auth.verifyPhoneNumber(
                    phoneNumber: phoneNumber.text,
                    verificationCompleted: (_) {},
                    verificationFailed: (e) {
                      Toast().toastMessage(e.toString());
                    },
                    codeSent: (String verificationId, int? token) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyPhone(
                                    verificationid: verificationId,
                                  )));
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Toast().toastMessage(e.toString());
                    });
              },
              title: "Next")
        ],
      ),
    );
  }
}
