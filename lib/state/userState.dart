import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/service/db_service.dart';

class UserState extends ChangeNotifier {
  String userData = "";
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DBService dbService = DBService();

  String isLoginCheck() {
    Stream<String> colsure() {
      return _auth.authStateChanges().map((event) {
        return event != null ? event.uid : "";
      });
    }

    if (userData == "") {
      colsure().listen((event) {
        userData = event;
        notifyListeners();
      });
    }
    return userData;
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print("SignIn Success: ${value}");
      });
      isLoading = false;
    } catch (e) {
      print("$e");
    }
  }

  Future<dynamic> signUp(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        print("SignUp Successfull: $value");
      });
      await dbService.signUp(email);
      return true;
    } catch (e) {
      print("$e");
      return e;
    }
  }

  void signOut() {
    _auth.signOut().then((value) => print("signOut Successfull"));
  }

  void reSetPwd(String email) {
    _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => print("emailSend Successfull"))
        .catchError((e) => {print("error: $e")});
  }
}
