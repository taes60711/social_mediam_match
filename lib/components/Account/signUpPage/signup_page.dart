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
//     UserState userFuture = context.read<UserState>();
//     String signError = context.select((UserState value) => value.signError);
//     int signUpIndex = context.select((UserState value) => value.signUpIndex);
//     String signUpedUserUID = context.select((UserState value) => value.signUpedUserUID);
//     TextEditingController emailController = context.select((UserState value) => value.emailController);
//     TextEditingController pwdController = context.select((UserState value) => value.pwdController);

//     TextEditingController nameController = context.select((UserSettingState value) => value.nameInput);
//     TextEditingController jobController = context.select((UserSettingState value) => value.jobInput);
//     TextEditingController introductionController = context.select((UserSettingState value) => value.introductionInput);

//     UserSettingState userSettingState = context.read<UserSettingState>();
//     GlobalKey<ScaffoldState> key = context.select((UserSettingState value) => value.key);
//     String type = context.select((UserSettingState value) => value.type);
//     //先暫時沒整理
//     List<SkillModel> forntSkillItems = context.watch<UserSettingState>().forntSkillList;
//     List<SkillModel> backEndSkillItems = context.watch<UserSettingState>().backEndSkillList;
//     List<SkillModel> iotSkillItems = context.watch<UserSettingState>().iotSkillList;
//     List<SkillModel> otherSkillItems = context.watch<UserSettingState>().otherSkillList;

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

//     void returnHomePage() {
//       Navigator.of(context).popUntil(ModalRoute.withName(RoutePath.home.value));
//     }

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

//     Widget signUpFirstPage = SignUpFirstPage(
//       emailController: emailController,
//       signErrorMessage: signErrorMessage,
//       userFuture: userFuture,
//     );

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
//       userSettingState: userSettingState,
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
//           userSettingState.getSkillListData();
//         }

//         resetAllInfo();
//       },
//       child: Scaffold(
//         key: key,
//         resizeToAvoidBottomInset: false,
//         endDrawer: SkillChoice(
//           userSettingState: userSettingState,
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
import 'package:social_mediam_match/states/user_setting_state.dart';

import '../../../global.dart';
import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/basic_top_bar.dart';

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

      List<Widget> signUpAllStepPage = [signUpStepOne(context), signUpStepTwo(context)];

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
            title: FirstPage().title,
          ),
          signUpAllStepPage[pageIndex],
        ],
      );
    },
  );
}

Widget signUpStepOne(BuildContext context) {
  SignUpViewProvider signUpViewProvider = Provider.of<SignUpViewProvider>(context, listen: false);

  return Column(
    children: [
      TitleInput(
        title: FirstPage().emailInputTitle,
        textController: signUpViewProvider.emailController,
      ),
      ElevatedButton(
        onPressed: () {
          signUpViewProvider.onChangeSignUpPage(1);
        },
        child: Text("to 1"),
      ),
    ],
  );
}

Widget signUpStepTwo(BuildContext context) {
  SignUpViewProvider signUpViewProvider = Provider.of<SignUpViewProvider>(context, listen: false);
  UserSettingState userSettingState = Provider.of<UserSettingState>(context, listen: false);
  return Column(
    children: [
      TitleInput(
        isRequired: true,
        title: StepOnePage().pwdInputTitle,
        textController: signUpViewProvider.pwdController,
      ),
      TitleInput(
        title: StepOnePage().nameInputTitle,
        textController: userSettingState.nameInput,
      ),
      ElevatedButton(
        onPressed: () {
          print("Email ${signUpViewProvider.emailController.text} Pwd ${signUpViewProvider.pwdController.text}");
        },
        child: Text("to 0"),
      ),
    ],
  );
}
