import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/firestore/fireadd.dart';
import 'package:firebase_login/firestore/firepost.dart';
import 'package:firebase_login/ui/home.dart';
import 'package:firebase_login/ui/login.dart';
import 'package:firebase_login/ui/signup.dart';
import 'package:flutter/material.dart';

class SplashService {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => NoteScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }
}
