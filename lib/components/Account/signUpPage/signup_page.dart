import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/signUpPage/signUP_step_one.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_first_page.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_guide.dart';
import 'package:social_mediam_match/components/account/signUpPage/signup_step_two.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/states/user_state.dart';

import '../../../models/skill_model.dart';
import '../../../states/user_setting_state.dart';
import '../../home/userPage/skill_choice.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/Icon_with_input.dart';

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

    UserSettingState userSettingState = context.read<UserSettingState>();
    GlobalKey<ScaffoldState> key = context.select((UserSettingState value) => value.key);
    String type = context.select((UserSettingState value) => value.type);
    //先暫時沒整理
    List<SkillModel> forntSkillItems = context.watch<UserSettingState>().forntSkillList;
    List<SkillModel> backEndSkillItems = context.watch<UserSettingState>().backEndSkillList;
    List<SkillModel> iotSkillItems = context.watch<UserSettingState>().iotSkillList;
    List<SkillModel> otherSkillItems = context.watch<UserSettingState>().otherSkillList;

    List<SkillModel> allSkillItems = [];
    List<SkillModel> allWantSkillItems = [];
    forntSkillItems.forEach((element) {
      if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
      if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
    });
    backEndSkillItems.forEach((element) {
      if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
      if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
    });
    iotSkillItems.forEach((element) {
      if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
      if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
    });
    otherSkillItems.forEach((element) {
      if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
      if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
    });
    //

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
      userFuture: userFuture,
    );

    Widget signUpThirdPage = SignUpStepTwo(
      userFuture: userFuture,
      allSkillItems: allSkillItems,
      allWantSkillItems: allWantSkillItems,
      userSettingState: userSettingState,
    );

    Widget guidePage = SignUpGuide(returnHomePage: returnHomePage);

    List<Widget> signUpPageList = [signUpFirstPage, signUpTwicePage, signUpThirdPage, guidePage];
    List<String> signStepList = ["step1", "step2", "step3"];
    return StatefulWrapper(
      onInit: () {
        userSettingState.getSkillListData();
        print("getSkillListData");
      },
      child: Scaffold(
        key: key,
        resizeToAvoidBottomInset: false,
        endDrawer: SkillChoice(
          userSettingState: userSettingState,
          forntSkillItems: forntSkillItems,
          backEndSkillItems: backEndSkillItems,
          iotSkillItems: iotSkillItems,
          otherSkillItems: otherSkillItems,
          allSkillItems: allSkillItems,
          allWantSkillItems: allWantSkillItems,
          type: type,
        ),
        body: BackgroundWidget(
          child: FittedBox(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
          // child: Stack(
          //   fit: StackFit.expand,
          //   children: [
          //     Column(
          //       children: [
          //         Align(
          //           alignment: Alignment.topLeft,
          //           child: IconButton(
          //             onPressed: () {
          //               if (signUpIndex == 0) {
          //                 returnHomePage();
          //               } else {
          //                 userFuture.onChangePage(signUpIndex - 1);
          //               }
          //             },
          //             icon: Icon(
          //               Icons.arrow_back_ios,
          //               color: normalBgColor2,
          //             ),
          //           ),
          //         ),
          //         signUpPageList[signUpIndex],
          //         Container(
          //           width: 100,
          //           height: 300,
          //           color: Colors.red,
          //         )
          //       ],
          //     ),
          //     Positioned(
          //       bottom: 50,
          //       left: 0,
          //       right: 0,
          //       child: signUpIndex != 0
          //           ? Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: signStepList.map((e) {
          //                 bool inPage = signStepList.indexOf(e) == signUpIndex - 1;
          //                 return inPage
          //                     ? Container(
          //                         margin: EdgeInsets.all(5),
          //                         width: 10,
          //                         height: 10,
          //                         decoration: BoxDecoration(
          //                           color: normalBgColor,
          //                           borderRadius: BorderRadius.circular(15.0),
          //                         ),
          //                       )
          //                     : Container(
          //                         margin: EdgeInsets.all(5),
          //                         width: 10,
          //                         height: 10,
          //                         decoration: BoxDecoration(
          //                           color: Color.fromARGB(255, 192, 191, 191),
          //                           borderRadius: BorderRadius.circular(15.0),
          //                         ),
          //                       );
          //               }).toList(),
          //             )
          //           : Container(),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
