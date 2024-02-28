import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_mediam_match/service/db_service.dart';

class FbService {
  FirebaseAuth auth = FirebaseAuth.instance;
  DBService dbService = DBService();

  Stream<User?> isLoginCheck() async* {
    User? user;
    await auth.authStateChanges().listen((event) {
      user = event;
    });
    yield user;
  }

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        log("SignIn isSuccess: ${value}");
        isSuccess = true;
      });
      return isSuccess;
    } catch (e) {
      log("$e");
      return isSuccess;
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
