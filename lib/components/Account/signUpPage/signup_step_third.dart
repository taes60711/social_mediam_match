// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_model.dart';
// import '../../../provider/home/user_setting_view_provider.dart';
// import '../../utilities/endDrawers/skill_setting_end_drawer.dart';
// import '../skill_bar.dart';
// import '../../strings/account/sign_up_strings.dart';
// import '../../utilities/custom_button.dart';
// import '../../utilities/style/style_config.dart';
// import '../../utilities/label_input.dart';

// class SignUpStepThird extends StatelessWidget {
//   const SignUpStepThird({super.key});

//   @override
//   Widget build(BuildContext context) {
//     UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();
//     print("signUpStepThird");

//     return Column(
//       children: [
//         LabelInput(
//           title: StepThirdPage.jobInputTitle,
//           textController: userSettingViewProvider.jobInput,
//         ),
//         // Builder(
//         //   builder: (context) {
//         //     print("signUpStepThird introductInput");
//         //     String displayText = context.select((UserSettingViewProvider value) => value.introductionInput.text);
//         //     return MultiLabelInput(
//         //       title: StepThirdPage.introInputTitle,
//         //       textController: userSettingViewProvider.introductionInput,
//         //       displayText: displayText,
//         //       multiOnChange: (value) => userSettingViewProvider.inputOnChange(value),
//         //     );
//         //   },
//         // ),
//         const SizedBox(height: 10),
//         skillSettingTitleBarBtn(SkillEndDrawerType.haveSkill),
//         const SizedBox(height: 20),
//         skillSettingTitleBarBtn(SkillEndDrawerType.wantSkill),
//         const SizedBox(height: 10),
//         sendBtn(context),
//       ],
//     );
//   }
// }

// Widget sendBtn(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//     child: TextBtn(
//       title: StepThirdPage.sendButtonText,
//       titleColor: normalTextColor,
//       btnColor: normalBgColor,
//       onPress: () async {
//         await SignUpViewModel(context: context).updateUserData();
//       },
//     ),
//   );
// }
