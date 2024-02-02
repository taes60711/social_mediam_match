import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class fbService {
  FirebaseAuth auth = FirebaseAuth.instance;

  void signIn(String email, String password) {
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => log("SignIn Successfull"))
        .catchError((e) => {log("error: $e")});
  }

  void signUp(String email, String password) {
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => log("SignUp Successfull"))
        .catchError((e) => {log("error: $e")});
  }

  void signOut() {
    auth.signOut().then((value) => log("signOut Successfull"));
  }
}
