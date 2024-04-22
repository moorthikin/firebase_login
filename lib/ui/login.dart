import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/flutterstorage/Imagescreen.dart';
import 'package:firebase_login/ui/home.dart';
import 'package:firebase_login/widgets/custom_button.dart';
import 'package:firebase_login/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void login() {
    setState(() {
      isLoading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ImageScreen()));
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Toast().toastMessage(error.toString());
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Login",
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
                      controller: emailController,
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
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
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
                  title: "Login",
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  }),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
