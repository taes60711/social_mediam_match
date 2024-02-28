import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:social_mediam_match/components/IconWithInput.dart';
import 'package:social_mediam_match/state/userState.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    UserState userFuture = context.read<UserState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              child: Container(
                width: 200,
                height: 200,
                color: Colors.blueAccent,
              ),
            ),
            IconWithInput(
              icon: Icons.email,
              inputController: emailController,
              hintText: 'Email',
            ),
            IconWithInput(
              icon: Icons.lock,
              inputController: pwdController,
              hintText: 'Password',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    log("忘記密碼?");
                    String email = emailController.text;
                    userFuture.reSetPwd(email);
                  },
                  child: const Text(
                    "忘記密碼?",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                emailController.text = "taes60711@gmail.com";
                pwdController.text = "toto60711";
                await userFuture.signIn(
                    emailController.text, pwdController.text);
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
