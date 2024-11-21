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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../provider/account/signUpPage/sign_up_view_model.dart';
// import '../../../provider/account/signUpPage/sign_up_view_provider.dart';
// import '../../../provider/home/user_setting_view_provider.dart';
// import '../../strings/account/sign_up_strings.dart';
// import '../../utilities/custom_button.dart';
// import '../../utilities/style/style_config.dart';
// import '../../utilities/label_input.dart';

// class SignUpStepTwo extends StatelessWidget {
//   const SignUpStepTwo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     print("signUpStepTwo");
//     SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
//     UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();

//     return Column(
//       children: [
//         LabelInput(
//           isRequired: true,
//           title: StepTwoPage.pwdInputTitle,
//           textController: signUpViewProvider.pwdController,
//         ),
//         LabelInput(
//           isRequired: true,
//           title: StepTwoPage.nameInputTitle,
//           textController: userSettingViewProvider.nameInput,
//         ),
//         Builder(
//           builder: (context) {
//             String signStepTwoError = context.select((SignUpViewProvider value) => value.signStepTwoError);
//             return Text(signStepTwoError, style: const TextStyle(color: Colors.red));
//           },
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: TextBtn(
//             title: StepTwoPage.signUpButtonText,
//             titleColor: normalTextColor,
//             btnColor: normalBgColor,
//             onPress: () async => await SignUpViewModel(context: context).signUpStart(),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';

import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';

import '../../utilities/inputField/label_input.dart';
import '../../utilities/inputField/mutl_input.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import '../account_main_page.dart';
import '../account_page_utilites.dart';

class SignUpStepThirdPage extends BaseEndDrawer {
  @override
  bool needGestureDetectorClosePage() {
    return false;
  }

  String? editImg;

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
        child: Column(
      children: [
        BaseTopBar(
          backFunc: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          rightWidget: MainBtn(
            onPress: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              ref.read(pageControllerProvider).jumpToPage(2);
            },
            title: "略過",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
          child: Column(
            children: [
              UserIcon(iconSize: 100, image: editImg),
              SizedBox(height: ScreenSize.fitPxWidth(15)),
              //アイコン選択
              MainBtn(
                padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(20), vertical: ScreenSize.fitPxWidth(8)),
                onPress: () async {},
                title: "選擇圖像",
              ),
              inputField(hintText: "職業", editingController: TextEditingController()),
              SizedBox(height: ScreenSize.fitPxWidth(16)),

              // 自己紹介
              multiInputField(hintText: "自我介紹", editingController: TextEditingController()),
              SizedBox(height: ScreenSize.fitPxWidth(20)),
              AccountPageUtilites().btnContainer(
                onPress: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ref.read(pageControllerProvider).jumpToPage(2);
                },
                btnText: "完成",
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget multiInputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize16;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(5)),
        MultInput(
          controller: TextEditingController(),
          hintText: hintText,
          minLines: 5,
          maxLines: 5,
          editPageMaxLines: 12,
          editPageMinLines: 12,
          hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: fs),
          inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
        ),
      ],
    );
  }

  Widget inputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize16;
    return LabelInput(
      controller: editingController,
      label: hintText,
      hintStyle: TextStyle(color: AppColors.greyColor98, fontSize: fs),
      inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
    );
  }
}
