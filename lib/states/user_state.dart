import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/messages/accooint_message.dart';
import 'package:social_mediam_match/service/db_service.dart';

class UserState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DBService dbService = DBService();
  String userData = "";
  bool isLoading = false;
  String resetPwdError = "";

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

  Future<void> reSetPwd(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Email Sended");

      resetPwdError = ResetPwdStatus.Success.value;
    } catch (e) {
      resetPwdError = ResetPwdStatus.Error.value;
      print("Email Error $resetPwdError");
      notifyListeners();
    }
  }
}
