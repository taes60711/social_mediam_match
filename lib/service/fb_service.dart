import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_mediam_match/service/db_service.dart';

class FbService {
  FirebaseAuth auth = FirebaseAuth.instance;
  DBService dbService = DBService();

  void signIn(String email, String password) {
    try {
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => log("SignIn Successfull"));
    } catch (e) {
      log("$e");
    }
  }

  Future<dynamic> signUp(String email, String password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        log("SignUp Successfull: $value");
      });
      await dbService.signUp(email);
      return true;
    } catch (e) {
      log("$e");
      return e;
    }
  }

  void signOut() {
    auth.signOut().then((value) => log("signOut Successfull"));
  }

  void reSetPwd(String email) {
    auth
        .sendPasswordResetEmail(email: email)
        .then((value) => log("emailSend Successfull"))
        .catchError((e) => {log("error: $e")});
  }
}
