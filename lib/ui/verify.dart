import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/ui/home.dart';
import 'package:firebase_login/widgets/custom_button.dart';
import 'package:firebase_login/widgets/toast.dart';
import 'package:flutter/material.dart';

class VerifyPhone extends StatelessWidget {
  VerifyPhone({super.key, required this.verificationid});
  String verificationid;
  final verifyNumbercontroller = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(" Verification Screen"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: verifyNumbercontroller,
              decoration: InputDecoration(
                hintText: "Enter your 6 digit pin",
                prefixIcon: Icon(Icons.phone),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          CustomButton(
              ontap: () async {
                final credential = PhoneAuthProvider.credential(
                    verificationId: verificationid,
                    smsCode: verifyNumbercontroller.text.toString());

                try {
                  auth.signInWithCredential(credential);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                } catch (e) {
                  Toast().toastMessage(e.toString());
                }
              },
              title: "Verify")
        ],
      ),
    );
  }
}
