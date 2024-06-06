// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print, avoid_function_literals_in_foreach_calls

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/account/signUpPage/signUP_step_one.dart';
// import 'package:social_mediam_match/components/account/signUpPage/signup_first_page.dart';
// import 'package:social_mediam_match/components/account/signUpPage/signup_guide.dart';
// import 'package:social_mediam_match/components/account/signUpPage/signup_step_two.dart';
// import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
// import 'package:social_mediam_match/components/utilities/background_widget.dart';
// import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
// import 'package:social_mediam_match/components/utilities/style/style_config.dart';
// import 'package:social_mediam_match/global.dart';
// import 'package:social_mediam_match/states/user_state.dart';

// import '../../../models/skill_model.dart';
// import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
// import '../../../states/user_setting_state.dart';
// import '../../home/userPage/skill_choice.dart';
// import '../../strings/account/sign_up_strings.dart';

// class SignUpPage extends StatelessWidget {
//   const SignUpPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     UserProvider userFuture = context.read<UserProvider>();
//     String signError = context.select((UserProvider value) => value.signError);
//     int signUpIndex = context.select((UserProvider value) => value.signUpIndex);
//     String signUpedUserUID = context.select((UserProvider value) => value.signUpedUserUID);
//     TextEditingController emailController = context.select((UserProvider value) => value.emailController);
//     TextEditingController pwdController = context.select((UserProvider value) => value.pwdController);

//     TextEditingController nameController = context.select((UserSettingProvider value) => value.nameInput);
//     TextEditingController jobController = context.select((UserSettingProvider value) => value.jobInput);
//     TextEditingController introductionController = context.select((UserSettingProvider value) => value.introductionInput);

//     UserSettingProvider UserSettingProvider = context.read<UserSettingProvider>();
//     GlobalKey<ScaffoldState> key = context.select((UserSettingProvider value) => value.key);
//     String type = context.select((UserSettingProvider value) => value.type);
//     //先暫時沒整理
//     List<SkillModel> forntSkillItems = context.watch<UserSettingProvider>().forntSkillList;
//     List<SkillModel> backEndSkillItems = context.watch<UserSettingProvider>().backEndSkillList;
//     List<SkillModel> iotSkillItems = context.watch<UserSettingProvider>().iotSkillList;
//     List<SkillModel> otherSkillItems = context.watch<UserSettingProvider>().otherSkillList;

//     List<SkillModel> allSkillItems = [];
//     List<SkillModel> allWantSkillItems = [];
//     forntSkillItems.forEach((element) {
//       if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
//       if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
//     });
//     backEndSkillItems.forEach((element) {
//       if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
//       if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
//     });
//     iotSkillItems.forEach((element) {
//       if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
//       if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
//     });
//     otherSkillItems.forEach((element) {
//       if (element.skillHave.level > 0) allSkillItems = [...allSkillItems, element];
//       if (element.skillWant.level > 0) allWantSkillItems = [...allWantSkillItems, element];
//     });
//     //

//     Widget signErrorMessage;
//     if (signError != SignUpError().noError) {
//       signErrorMessage = SizedBox(
//         width: ScreenSize().width,
//         child: Align(
//           alignment: Alignment.topLeft,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Text(
//               signError,
//               style: const TextStyle(color: Colors.red),
//             ),
//           ),
//         ),
//       );
//     } else {
//       signErrorMessage = Container();
//     }

//     Widget signUpTwicePage = SignUpStepOne(
//       emailController: emailController,
//       nameController: nameController,
//       pwdController: pwdController,
//       signErrorMessage: signErrorMessage,
//       userFuture: userFuture,
//     );

//     Widget signUpThirdPage = SignUpStepTwo(
//       userFuture: userFuture,
//       signUpedUserUID: signUpedUserUID,
//       allSkillItems: allSkillItems,
//       allWantSkillItems: allWantSkillItems,
//       UserSettingProvider: UserSettingProvider,
//       nameController: nameController,
//       jobController: jobController,
//       introductionController: introductionController,
//     );

//     Widget guidePage = SignUpGuide(returnHomePage: returnHomePage);

//     List<Widget> signUpPageList = [signUpFirstPage, signUpTwicePage, signUpThirdPage, guidePage];
//     List<String> signStepList = ["step1", "step2", "step3"];

//     _stepView(List<String> signStepList) {
//       circle(Color bgColor) {
//         return Container(
//           margin: const EdgeInsets.all(5),
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//         );
//       }

//       return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: signStepList.map((e) {
//           bool inPage = signStepList.indexOf(e) == signUpIndex - 1;
//           return inPage ? circle(normalBgColor) : circle(const Color.fromARGB(255, 192, 191, 191));
//         }).toList(),
//       );
//     }

//     Widget stepView;
//     if (signUpIndex != 0) {
//       stepView = _stepView(signStepList);
//     } else {
//       stepView = Container();
//     }

//     print("object");
//     return StatefulWrapper(
//       onInit: () {
//         print("getSkillListData");

//         resetAllInfo() {
//           userFuture.onChangeSignUpPage(0);
//           UserSettingProvider.getSkillListData();
//         }

//         resetAllInfo();
//       },
//       child: Scaffold(
//         key: key,
//         resizeToAvoidBottomInset: false,
//         endDrawer: SkillChoice(
//           UserSettingProvider: UserSettingProvider,
//           forntSkillItems: forntSkillItems,
//           backEndSkillItems: backEndSkillItems,
//           iotSkillItems: iotSkillItems,
//           otherSkillItems: otherSkillItems,
//           allSkillItems: allSkillItems,
//           allWantSkillItems: allWantSkillItems,
//           type: type,
//         ),
//         body: BackgroundWidget(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: ScreenSize().safeheight,
//                 child: FittedBox(
//                   alignment: Alignment.topLeft,
//                   child: Column(
//                     children: [
//                       backButton,
//                       signUpPageList[signUpIndex],
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: ScreenSize().safeheight * 0.05,
//                 child: stepView,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_model.dart';
import 'package:social_mediam_match/states/user_setting_provider.dart';

import '../../../global.dart';
import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/basic_top_bar.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("signUP build");

    return Scaffold(
      body: BackgroundWidget(
        isSafeArea: true,
        child: _mainBuild(),
      ),
    );
  }
}

Widget _mainBuild() {
  return Selector<SignUpViewProvider, int>(
    selector: (context, provider) => provider.pageIndex,
    builder: (context, pageIndex, _) {
      SignUpViewProvider signUpViewProvider = Provider.of<SignUpViewProvider>(context, listen: false);

      List<Widget> signUpAllStepPage = [
        signUpStepOne(context),
        signUpStepTwo(context),
        signUpStepThird(context),
        signUpStepGuide(context),
      ];
      List<String> signUpStepTitle = [
        FirstPage().title,
        StepOnePage().title,
        StepTwoPage().title,
        StepGuide().title,
      ];

      print("SignUpViewProvider pageIndex Change");

      return Column(
        children: [
          BasicTopBar(
            backFunc: () {
              int preIndex = signUpViewProvider.pageIndex - 1;
              if (preIndex < 0) {
                Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
              } else {
                signUpViewProvider.onChangeSignUpPage(preIndex);
              }
            },
            title: signUpStepTitle[pageIndex],
          ),
          signUpAllStepPage[pageIndex],
        ],
      );
    },
  );
}

Widget signUpStepOne(BuildContext context) {
  SignUpViewProvider signUpViewProvider = Provider.of<SignUpViewProvider>(context, listen: false);

  String googleIconPath = 'assets/google_w_Logo.png';
  Color googleButtonColor = const Color.fromARGB(255, 93, 161, 238);

  String twitterIconPath = 'assets/twitter_w_Logo.png';
  Color twitterButtonColor = const Color.fromARGB(255, 41, 41, 41);

  //紹介文章
  final Widget introductionWidget = SizedBox(
    width: ScreenSize().width,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        FirstPage().introduction,
        style: TextStyle(color: hintTextColor, fontSize: 14),
      ),
    ),
  );

  //プライバシー
  final Widget privacy = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
    child: SizedBox(
      width: ScreenSize().width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FirstPage().hintText,
            style: TextStyle(color: hintTextColor, fontSize: 14),
          ),
          GestureDetector(
            onTap: () {
              print("使用者條款");
            },
            child: Text(
              FirstPage().termText,
              style: TextStyle(color: normalBgColor, fontSize: 14),
            ),
          ),
          Text(
            FirstPage().andText,
            style: TextStyle(color: hintTextColor, fontSize: 14),
          ),
          GestureDetector(
            onTap: () {
              print("隱私權政策");
            },
            child: Text(
              FirstPage().privacyText,
              style: TextStyle(color: normalBgColor, fontSize: 14),
            ),
          ),
        ],
      ),
    ),
  );

  //or テキスト
  orText() {
    line({required EdgeInsetsGeometry padding}) {
      return Expanded(
        child: Padding(
          padding: padding,
          child: Container(
            height: 1,
            color: Colors.black45,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: ScreenSize().width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          line(padding: const EdgeInsets.only(left: 20, right: 10)),
          Text(FirstPage().orText),
          line(padding: const EdgeInsets.only(left: 10, right: 20)),
        ],
      ),
    );
  }

  //ボタン
  //param:
  //title: ボタン内の文字、　titleColor:　ボタン内の文字の色
  //backgroundColor: ボタンの色、　onPressed: ボタンの機能関数
  _button({required title, required titleColor, required backgroundColor, required onPressed, String? iconImg}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomButton(
        title: title,
        titleColor: titleColor,
        iconImg: iconImg,
        backgroundColor: backgroundColor,
        onPress: onPressed,
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      introductionWidget,
      privacy,
      TitleInput(
        title: FirstPage().emailInputTitle,
        textController: signUpViewProvider.emailController,
      ),
      Selector<SignUpViewProvider, String>(
        selector: (context, provider) => provider.signError,
        builder: (context, signError, _) {
          return Text(signError, style: const TextStyle(color: Colors.red));
        },
      ),
      _button(
        title: FirstPage().emailButtonText,
        titleColor: normalTextColor,
        backgroundColor: normalBgColor,
        onPressed: () {
          print("SignUpViewProvider Btn");
          SignUpViewModel().emailCheck(context);
        },
      ),
      orText(),
      _button(
          title: FirstPage().googleButtonText,
          titleColor: normalTextColor,
          backgroundColor: googleButtonColor,
          iconImg: googleIconPath,
          onPressed: () {
            print("Google 登入");
          }),
      const SizedBox(height: 10),
      //ツイッター登録ボタン
      _button(
          title: FirstPage().twitterButtonText,
          titleColor: normalTextColor,
          backgroundColor: twitterButtonColor,
          iconImg: twitterIconPath,
          onPressed: () {
            print("Twitter 登入");
          }),
    ],
  );
}

Widget signUpStepTwo(BuildContext context) {
  SignUpViewProvider signUpViewProvider = Provider.of<SignUpViewProvider>(context, listen: false);
  UserSettingProvider userSettingProvider = Provider.of<UserSettingProvider>(context, listen: false);

  return Column(
    children: [
      TitleInput(
        isRequired: true,
        title: StepOnePage().pwdInputTitle,
        textController: signUpViewProvider.pwdController,
      ),
      TitleInput(
        title: StepOnePage().nameInputTitle,
        textController: userSettingProvider.nameInput,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomButton(
          title: StepOnePage().signUpButtonText,
          titleColor: normalTextColor,
          backgroundColor: normalBgColor,
          onPress: () async {
            await SignUpViewModel().signUpStart(context);
          },
        ),
      ),
    ],
  );
}

Widget signUpStepThird(BuildContext context) {
  SignUpViewProvider signUpViewProvider = Provider.of<SignUpViewProvider>(context, listen: false);
  UserSettingProvider userSettingProvider = Provider.of<UserSettingProvider>(context, listen: false);
  return Column(
    children: [
      TitleInput(
        title: StepTwoPage().jobInputTitle,
        textController: userSettingProvider.jobInput,
      ),
      TitleInput(
        title: StepTwoPage().introInputTitle,
        textController: userSettingProvider.introductionInput,
        isMulti: true,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomButton(
          title: StepTwoPage().sendButtonText,
          titleColor: normalTextColor,
          backgroundColor: normalBgColor,
          onPress: () async {
            signUpViewProvider.onChangeSignUpPage(3);
          },
        ),
      ),
    ],
  );
}

Widget signUpStepGuide(BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomButton(
          title: StepGuide().skipButtonText,
          titleColor: normalTextColor,
          backgroundColor: normalBgColor,
          onPress: () async {
            Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
          },
        ),
      ),
    ],
  );
}
