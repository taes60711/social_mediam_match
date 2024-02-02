import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/service/fb_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.email,
                    size: 36,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                    size: 36,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: TextField(
                        controller: pwdController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    log("忘記帳號?");
                  },
                  child: const Text(
                    "忘記帳號?",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text;
                String pwd = pwdController.text;
                log("signIn $email Pwd:$pwd");
                fireBaseService.signIn(email, pwd);
                Navigator.of(context).pushNamed(
                  '/home',
                );
              },
              child: const Text("登入"),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("第三方登入(功能暫不處理)"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    log("Google 登入");
                  },
                  child: const Text("Google 登入"),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    log("Twitter 登入");
                  },
                  child: const Text("Twitter 登入"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Text("還沒有帳戶?"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/signUp',
                    );
                  },
                  child: const Text(
                    "建立帳戶",
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
