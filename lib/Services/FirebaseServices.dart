import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym/Components/snackBar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method
  Future<User?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      CustomSnackBar(context, Text('Error: $e'));
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      CustomSnackBar(context, Text('Error: $e'));
      return null;
    }
  }
}
