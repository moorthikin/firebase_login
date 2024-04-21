import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/ui/home.dart';
import 'package:firebase_login/ui/login.dart';
import 'package:firebase_login/ui/phone.dart';
import 'package:firebase_login/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_login/widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Toast toast = Toast();
  final _formKey = GlobalKey<FormState>();
  final semailController = TextEditingController();
  final spasswordController = TextEditingController();
  bool isLoading = false;

  void signup() {
    setState(() {
      isLoading = true;
    });
    auth
        .createUserWithEmailAndPassword(
            email: semailController.text.toString(),
            password: spasswordController.text.toString())
        .then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      toast.toastMessage(error.toString());
    });
  }

  @override
  void Dispose() {
    super.dispose();
    semailController.dispose();
    spasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Sign up screen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: semailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.email)),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "enter your email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: spasswordController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Enter your password",
                      prefixIcon: Icon(Icons.password),
                    ),
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "enter password";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: CustomButton(
                loading: isLoading,
                title: "Sign up",
                ontap: () {
                  if (_formKey.currentState!.validate()) {
                    signup();
                  }
                }),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    "Log in",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: CustomButton(
                ontap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PhoneSignup()));
                },
                title: "Logi with phone number"),
          )
        ],
      ),
    );
  }
}
