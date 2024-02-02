import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  Home({super.key});
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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

    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                String email = "taes60711@gmail.com";
                String password = "toto60711";
                log("signIn");
                signIn(email, password);
              },
              child: Container(
                width: 100,
                height: 30,
                color: Colors.blue,
                child: const Center(
                  child: Text("login"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                log("signOut");
                signOut();
              },
              child: Container(
                width: 100,
                height: 30,
                color: Colors.blue,
                child: const Center(
                  child: Text("signOut"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pwdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                String email = emailController.text;
                String pwd = pwdController.text;
                log("signUp Email:$email Pwd:$pwd");

                signUp(email, pwd);
              },
              child: Container(
                width: 100,
                height: 30,
                color: Colors.blue,
                child: const Center(
                  child: Text("signUp"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
