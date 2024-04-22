import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/states/user_state.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();
    String signError = context.select((UserState value) => value.signError);
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();

    void returnLoginPage() {
      resetAllInfo() {
        userFuture.signError = SignUpStatus.NoMessage.value;
      }

      Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
      resetAllInfo();
    }

    Widget signErrorMessage;
    if (signError != SignUpStatus.NoMessage.value) {
      signErrorMessage = Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            signError,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      signErrorMessage = Container();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  returnLoginPage();
                },
                icon: Icon(Icons.arrow_back_ios),
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
            signErrorMessage,
            GestureDetector(
                onTap: () async {
                  String email = emailController.text;
                  String pwd = pwdController.text;
                  log("signUpPage Email:$email Pwd:$pwd");
                  bool isSignSucess = await userFuture.signUp(email, pwd);
                  isSignSucess ? returnLoginPage() : () {};
                },
                child: Container(
                  width: ScreenSize().width,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(246, 138, 89, 1),
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                  ),
                  child: Center(child: Text("註冊")),
                )),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 20,
                        height: 1,
                        color: Colors.black45,
                      ),
                    ),
                    const Text("或"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 20,
                        height: 1,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )),
            GestureDetector(
              onTap: () {
                log("Google 登入");
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Color.fromRGBO(66, 82, 95, 1)),
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      child: Image.asset('assets/google_Logo.png', fit: BoxFit.cover),
                    ),
                    SizedBox(width: 10),
                    const Text("Google 登入"),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                log("X (Twitter) 登入");
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Color.fromRGBO(66, 82, 95, 1)),
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      child: Image.asset('assets/twitter_Logo.png', fit: BoxFit.cover),
                    ),
                    SizedBox(width: 10),
                    const Text("X (Twitter) 登入"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
