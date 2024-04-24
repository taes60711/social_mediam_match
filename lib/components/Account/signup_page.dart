import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/states/user_state.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userFuture = context.read<UserState>();
    String signError = context.select((UserState value) => value.signError);
    int signUpIndex = context.select((UserState value) => value.signUpIndex);
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();

    void returnHomePage() {
      resetAllInfo() {
        userFuture.signUpErrorReset();
        userFuture.onChangePage(0);
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

    Widget signUpFirstPage = Column(
      children: [
        Text("SMM用戶註冊"),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "歡迎使用SMM  請利用一段時間註冊帳號並設定個人資料",
              style: TextStyle(color: hintTextColor, fontSize: 14),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("常用信箱"),
              SizedBox(
                height: 36,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        signErrorMessage,
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  '註冊即代表同意 ',
                  style: TextStyle(color: hintTextColor, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    print("使用者條款");
                  },
                  child: Text(
                    '使用者條款',
                    style: TextStyle(color: Color.fromRGBO(246, 138, 89, 1), fontSize: 14),
                  ),
                ),
                Text(' 與 ', style: TextStyle(color: hintTextColor, fontSize: 14)),
                GestureDetector(
                  onTap: () {
                    print("使用者條款");
                  },
                  child: Text(
                    '隱私權政策',
                    style: TextStyle(color: Color.fromRGBO(246, 138, 89, 1), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Material(
            color: Color.fromRGBO(246, 138, 89, 1),
            borderRadius: BorderRadius.circular(15.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () {
                bool isEmail = userFuture.signUpEmailCheck(emailController.text);
                if (isEmail) {
                  userFuture.onChangePage(1);
                  userFuture.signUpErrorReset();
                }
              },
              child: Container(
                width: ScreenSize().width,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                    child: Text(
                  "信箱登入",
                  style: TextStyle(color: Color.fromARGB(255, 243, 239, 231)),
                )),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: ScreenSize().width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Container(
                    width: 20,
                    height: 1,
                    color: Colors.black45,
                  ),
                ),
              ),
              const Text("或"),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Container(
                    width: 20,
                    height: 1,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            color: Color.fromARGB(255, 93, 161, 238),
            borderRadius: BorderRadius.circular(15.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () {
                log("Google 登入");
              },
              child: Container(
                width: ScreenSize().width,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      child: Image.asset('assets/google_w_Logo.png', fit: BoxFit.contain),
                    ),
                    SizedBox(width: 10),
                    const Text(
                      "Google 登入",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            color: Color.fromARGB(255, 41, 41, 41),
            borderRadius: BorderRadius.circular(15.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () {
                log("Twitter 登入");
              },
              child: Container(
                width: ScreenSize().width,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      child: Image.asset('assets/twitter_w_Logo.png', fit: BoxFit.contain),
                    ),
                    SizedBox(width: 10),
                    const Text(
                      "Twitter 登入",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

    Widget signUpTwicePage = Column(
      children: [
        Text("SMM用戶註冊"),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("使用者名稱"),
              SizedBox(
                height: 36,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("密碼"),
              SizedBox(
                height: 36,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              signErrorMessage,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Material(
                  color: Color.fromRGBO(246, 138, 89, 1),
                  borderRadius: BorderRadius.circular(15.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () async {
                      userFuture.onChangePage(2);
                      // String email = emailController.text;
                      // String pwd = pwdController.text;
                      // log("signUpPage Email:$email Pwd:$pwd");
                      // bool isSignSucess = await userFuture.signUp(email, pwd);
                      // isSignSucess ? returnHomePage() : () {};
                    },
                    child: Container(
                      width: ScreenSize().width,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          "註冊",
                          style: TextStyle(color: Color.fromARGB(255, 243, 239, 231)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    Widget signUpThirdPage = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text("個人資料設定")),
        SizedBox(height: 10),
        Text("職業"),
        SizedBox(
          height: 36,
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Material(
            color: Color.fromRGBO(246, 138, 89, 1),
            borderRadius: BorderRadius.circular(15.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                userFuture.onChangePage(3);
              },
              child: Container(
                width: ScreenSize().width,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "送出",
                    style: TextStyle(color: Color.fromARGB(255, 243, 239, 231)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    Widget guidePage = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(
          "導覽",
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Material(
            color: Color.fromRGBO(246, 138, 89, 1),
            borderRadius: BorderRadius.circular(15.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                returnHomePage();
              },
              child: Container(
                width: ScreenSize().width,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "跳過",
                    style: TextStyle(color: Color.fromARGB(255, 243, 239, 231)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    List<Widget> signUpPageList = [signUpFirstPage, signUpTwicePage, signUpThirdPage, guidePage];
    List<String> signStepList = ["step1", "step2", "step3"];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  if (signUpIndex == 0) {
                    returnHomePage();
                  } else {
                    userFuture.onChangePage(signUpIndex - 1);
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: normalBgColor2,
                ),
              ),
            ),
            signUpPageList[signUpIndex],
            signUpIndex != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: signStepList.map((e) {
                      bool inPage = signStepList.indexOf(e) == signUpIndex - 1;
                      return inPage
                          ? Container(
                              margin: EdgeInsets.all(5),
                              width: 10,
                              height: 10,
                              color: normalBgColor,
                            )
                          : Container(
                              margin: EdgeInsets.all(5),
                              width: 10,
                              height: 10,
                              color: Color.fromARGB(255, 192, 191, 191),
                            );
                    }).toList(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
