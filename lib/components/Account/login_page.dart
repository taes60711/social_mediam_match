import 'dart:developer';
import 'package:social_mediam_match/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Icon_with_input.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/states/user_state.dart';
import 'package:social_mediam_match/utilities/screen_size.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    UserState userFuture = context.read<UserState>();
    String loginError = context.select((UserState value) => value.loginError);

    void closeResetPwdWindow() {
      userFuture.resetPwdError = ResetPwdStatus.NoMessage.value;
      Navigator.pop(context);
    }

    openBottomSheet() {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            String resetPwdError = context.select((UserState value) => value.resetPwdError);
            return SizedBox(
              height: ScreenSize().height * .55,
              child: Stack(
                children: [
                  Positioned(
                    top: 30,
                    bottom: 0,
                    child: Container(
                      width: ScreenSize().width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("請輸入註冊時的郵箱地址:"),
                            IconWithInput(
                              icon: Icons.email,
                              inputController: emailController,
                              hintText: 'Email',
                            ),
                            Text(
                              resetPwdError,
                              style: const TextStyle(color: Colors.red),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () => userFuture.reSetPwd(emailController.text),
                                child: const Text("發送"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 25,
                      child: GestureDetector(
                        onTap: () => closeResetPwdWindow(),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 88, 127, 226),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ),
                      ))
                ],
              ),
            );
          });
    }

    void ReturnHome() {
      resetAllInfo() {
        userFuture.loginError = LoginStatus.NoMessage.value;
      }

      Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
      resetAllInfo();
    }

    Widget loginErrorMessage;
    if (loginError != LoginStatus.NoMessage.value) {
      loginErrorMessage = Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            loginError,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      loginErrorMessage = Container();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () => ReturnHome(),
                child: Text("返回"),
              ),
            ),
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
            loginErrorMessage,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    openBottomSheet();
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
                bool isLoginSucess = await userFuture.signIn(emailController.text, pwdController.text);
                isLoginSucess ? ReturnHome() : () {};
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
                      RoutePath.signUpPage.value,
                    );
                  },
                  child: const Text(
                    "建立帳戶",
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
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
