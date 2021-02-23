//Firebase connection class
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FirebaseController {
  /*
  static Future<String> createAccount({String email, String password}) async {
    AuthResult auth = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    return auth.user.uid;
  }
  */

  static Future<User> login(
      {@required String email, @required String password}) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}