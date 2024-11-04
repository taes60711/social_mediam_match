// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/account/signUpPage/signup_step_third.dart';
// import 'package:social_mediam_match/components/account/signUpPage/signup_step_two.dart';
// import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
// import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
// import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_model.dart';
// import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
// import '../../../provider/home/skill_map_provider.dart';
// import '../../strings/account/sign_up_strings.dart';
// import '../../utilities/background_widget.dart';
// import '../../utilities/basic_top_bar.dart';
// import '../../utilities/endDrawers/skill_setting_end_drawer.dart';
// import '../../utilities/fit_widget.dart';
// import 'signup_step_guide.dart';
// import 'signup_step_one.dart';

// class SignUpPage extends StatelessWidget {
//   const SignUpPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     print("signUP build");

//     return Stack(
//       children: [
//         BackgroundWidget(
//           isSafeArea: true,
//           child: StatefulWrapper(
//             onInit: () async {
//               SkillMapProvider skillProvider = context.read<SkillMapProvider>();
//               await skillProvider.userSkillList();
//             },
//             child: _mainBuild(),
//           ),
//         ),
//         skillSettingEndDrawer(),
//       ],
//     );
//   }
// }

// Widget _mainBuild() {
//   return Builder(
//     builder: (context) {
//       print("SignUpViewProvider pageIndex Change");
//       int pageIndex = context.select((SignUpViewProvider value) => value.pageIndex);

//       List<Widget> signUpAllStepPage = [
//         const SignUpStepOne(),
//         const SignUpStepTwo(),
//         const SignUpStepThird(),
//         // const SignUpStepGuide(),
//       ];

//       List<String> signUpStepTitle = [
//         StepOnePage.title,
//         StepTwoPage.title,
//         StepThirdPage.title,
//         StepGuide.title,
//       ];

//       List<Widget> signUpLeftWidget = [
//         GestureDetector(
//           onTap: () => SignUpViewModel(context: context).backButtonFUnc(),
//           child: const Icon(Icons.arrow_back_ios),
//         ),
//         GestureDetector(
//           onTap: () => SignUpViewModel(context: context).backButtonFUnc(),
//           child: const Icon(Icons.arrow_back_ios),
//         ),
//         Container(),
//         Container(),
//       ];

//       List<Widget> signUpRightWidget = [
//         Container(),
//         Container(),
//         GestureDetector(
//           onTap: () => context.read<SignUpViewProvider>().onChangeSignUpPage(3),
//           child: Text(StepGuide.skipButtonText),
//         ),
//         Container(),
//       ];

//       return Column(
//         children: [
//           //タイトル
//           FitWidget(
//             height: ScreenSize.height * 0.08,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: BaseTopBar(
//                 leftWidget: signUpLeftWidget[pageIndex],
//                 rightWidget: signUpRightWidget[pageIndex],
//                 title: signUpStepTitle[pageIndex],
//               ),
//             ),
//           ),

//           ///登録ステップコンテンツ
//           FitWidget(
//             height: ScreenSize.height * 0.8,
//             child: signUpAllStepPage[pageIndex],
//           ),
//         ],
//       );
//     },
//   );
// }
