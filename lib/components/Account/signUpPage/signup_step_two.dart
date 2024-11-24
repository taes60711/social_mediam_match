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
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';
import '../../utilities/inputField/label_input.dart';
import '../../utilities/style/screen_size.dart';
import '../account_page_utilites.dart';
import 'signup_page.dart';
import 'signup_step_third.dart';

class SignUpStepTwoPage extends BaseEndDrawer {
  @override
  bool needGestureDetectorClosePage() {
    return false;
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
        child: Column(
      children: [
        BaseTopBar(
          backFunc: () => closePage(),
          title: "註冊(1/2)",
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
          child: Column(
            children: [
              verifyBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              pwdBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(16)),
              idBuild(),
              SizedBox(height: ScreenSize.fitPxWidth(25)),
              AccountPageUtilites().btnContainer(
                onPress: () async {
                  if (await ref.read(viewModelProvider.notifier).state.signUp()) {
                    SignUpStepThirdPage().show(context);
                  }
                  render();
                },
                btnText: "下一步",
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget verifyBuild() {
    return LabelInput(
      controller: ref.read(viewModelProvider.notifier).state.verifyController,
      label: "驗證碼",
      errMsg: [ref.read(viewModelProvider.notifier).state.verifyErr],
    );
  }

  Widget pwdBuild() {
    return LabelInput(
      type: InputType.pwd,
      controller: ref.read(viewModelProvider.notifier).state.passwordController,
      label: "密碼",
      errMsg: [
        ref.read(viewModelProvider.notifier).state.pwdleastSixErr,
        ref.read(viewModelProvider.notifier).state.pwdNeedNumErr,
        ref.read(viewModelProvider.notifier).state.pwdNeedEnglishErr
      ],
    );
  }

  Widget idBuild() {
    return LabelInput(
      controller: ref.read(viewModelProvider.notifier).state.nameController,
      label: "名稱",
      errMsg: [ref.read(viewModelProvider.notifier).state.nameErr],
    );
  }
}
