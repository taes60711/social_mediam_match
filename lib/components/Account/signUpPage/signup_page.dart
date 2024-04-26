import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/signUpPage/signUP_step_one.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_first_page.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_guide.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_step_two.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
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
    TextEditingController nameController = context.select((UserState value) => value.nameController);
    TextEditingController emailController = context.select((UserState value) => value.emailController);
    TextEditingController pwdController = context.select((UserState value) => value.pwdController);

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

    Widget signUpFirstPage = SignUpFirstPage(
      emailController: emailController,
      signErrorMessage: signErrorMessage,
      userFuture: userFuture,
    );

    Widget signUpTwicePage = SignUpStepOne(
        emailController: emailController,
        nameController: nameController,
        pwdController: pwdController,
        signErrorMessage: signErrorMessage,
        userFuture: userFuture);

    Widget signUpThirdPage = SignUpStepTwo(userFuture: userFuture);

    Widget guidePage = SignUpGuide(returnHomePage: returnHomePage);

    List<Widget> signUpPageList = [signUpFirstPage, signUpTwicePage, signUpThirdPage, guidePage];
    List<String> signStepList = ["step1", "step2", "step3"];
    return BackgroundWidget(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
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
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: signUpIndex != 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: signStepList.map((e) {
                      bool inPage = signStepList.indexOf(e) == signUpIndex - 1;
                      return inPage
                          ? Container(
                              margin: EdgeInsets.all(5),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: normalBgColor,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.all(5),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 192, 191, 191),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            );
                    }).toList(),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
