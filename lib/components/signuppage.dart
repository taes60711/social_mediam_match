import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/service/fb_service.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    FbService fireBaseService = FbService();
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    emailController.text = "taes60711@gmail.com";
    pwdController.text = "toto60711";
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
            ElevatedButton(
              onPressed: () {
                String email = emailController.text;
                String pwd = pwdController.text;
                log("signUp Email:$email Pwd:$pwd");

                fireBaseService.signUp(email, pwd);
              },
              child: const Text("註冊"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("已經有帳戶"),
            ),
          ],
        ),
      ),
    );
  }
}
