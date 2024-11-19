// import 'package:social_mediam_match/components/strings/account/login_strings.dart';
// import 'package:social_mediam_match/components/utilities/background_widget.dart';

// import 'package:social_mediam_match/components/utilities/custom_button.dart';
// import 'package:social_mediam_match/components/utilities/fit_widget.dart';
// import 'package:social_mediam_match/components/utilities/style/style_config.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/utilities/label_input.dart';
// import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
// import 'package:social_mediam_match/provider/account/LoginPage/login_provider.dart';
// import 'package:social_mediam_match/provider/account/LoginPage/login_view_model.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController emailController = context.read<LoginProvider>().emailController;
//     TextEditingController pwdController = context.read<LoginProvider>().pwdController;

//     emailController.text = "taes60811@gmail.com";
//     pwdController.text = "toto60811";

//     return BackgroundWidget(
//       resizeToAvoidBottomInset: true,
//       child: Column(
//         children: [
//           // backButton,
//           // BaseTopBar(backFunc: () => RouteOptions.popUntilToHome()),
//           //ロゴ
//           logo,
//           Column(
//             children: [
//               FitWidget(
//                 height: ScreenSize.safeHeight * 0.6,
//                 alignment: Alignment.center,
//                 child: Column(
//                   children: [
//                     //メールアドレスInput
//                     LabelInput(title: Login.emailInputTitle, textController: emailController),
//                     //パスワードInput
//                     LabelInput(title: Login.pwdInputTitle, textController: pwdController),
//                     //エラーメッセージ
//                     errorMessage(),
//                     //パスワード忘れるテキスト
//                     forgotPwdText(loginViewContext: context),
//                     //ログインボタン
//                     _button(
//                       title: Login.emailLoginButtonText,
//                       titleColor: normalTextColor,
//                       backgroundColor: normalBgColor,
//                       onPressed: () async => await LoginViewModel(loginViewContext: context).loginStart(),
//                     ),
//                     const SizedBox(height: 10),

//                     //グーグル登録ボタン
//                     _button(
//                         title: Login.googleButtonText,
//                         titleColor: normalTextColor,
//                         backgroundColor: googleButtonColor,
//                         iconImg: googleIcon,
//                         onPressed: () {
//                           print("Google 登入");
//                         }),
//                     const SizedBox(height: 10),
//                     //ツイッター登録ボタン
//                     _button(
//                         title: Login.twitterButtonText,
//                         titleColor: normalTextColor,
//                         backgroundColor: twitterButtonColor,
//                         iconImg: twitterIcon,
//                         onPressed: () {
//                           print("Twitter 登入");
//                         }),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// ///ボタン
// ///title: ボタン内文字、　titleColor:　ボタン内文字の色
// ///backgroundColor: ボタンの色、　onPressed: ボタンの機能関数
// _button({required title, required titleColor, required backgroundColor, required onPressed, String? iconImg}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20),
//     child: iconImg == null
//         ? TextBtn(
//             title: title,
//             onPress: () {
//               onPressed();
//             },
//           )
//         : RowImgBtn(
//             title: title,
//             titleColor: titleColor,
//             img: iconImg,
//             btnColor: backgroundColor,
//             onPress: () {
//               onPressed();
//             },
//           ),
//   );
// }

// ///ロゴ
// Widget logo = SizedBox(
//   height: ScreenSize.safeHeight * 0.4,
//   child: Image.asset(
//     logoImg,
//     width: 150,
//     height: 150,
//   ),
// );

// ///ログインのエラーメッセージ
// Widget errorMessage() {
//   return Builder(builder: (context) {
//     String sLoginError = context.select((LoginProvider value) => value.loginError);
//     Widget wErrText = Container();
//     if (sLoginError != LoginError.noError) {
//       wErrText = SizedBox(
//         width: ScreenSize.width,
//         child: Align(
//           alignment: Alignment.topLeft,
//           child: Text(
//             sLoginError,
//             style: const TextStyle(color: Colors.red),
//           ),
//         ),
//       );
//     }
//     return wErrText;
//   });
// }

// ///パスワード忘れるテキスト
// Widget forgotPwdText({required BuildContext loginViewContext}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 10),
//     child: SizedBox(
//       width: ScreenSize.width,
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: GestureDetector(
//           onTap: () => LoginViewModel(loginViewContext: loginViewContext).openPwdResetWindow(),
//           child: Text(
//             Login.forgotPassword,
//             style: TextStyle(color: googleButtonColor),
//           ),
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/inputField/label_input.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/global/user_login_status_controller.dart';
import 'package:social_mediam_match/services/firebase_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController accountController = TextEditingController(text: "tzLaMcP3V9XOAMOcD0FAY5Nf4tE2");
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LabelInput(controller: accountController, label: "Email"),
          SizedBox(height: ScreenSize.fitPxWidth(16)),
          MainBtn(
            onPress: () async {
              ///tzLaMcP3V9XOAMOcD0FAY5Nf4tE2
              UserLoginStatusController().login(userUID: accountController.text);
            },
            title: "login",
          ),
          SizedBox(height: ScreenSize.fitPxWidth(16)),
          // MainBtn(
          //   onPress: () {
          //     FirebaseSerivce().signInWithGoogle();
          //   },
          //   title: "google signIn",
          // ),
        ],
      ),
    ));
  }
}
