import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/account/signUpPage/sign_up_view_provider.dart';

import '../../../components/utilities/style/style_config.dart';
import '../../../models/user_model.dart';

import '../../../route_options.dart';
import '../../../services/firebase_service.dart';
import '../../../services/user_service.dart';
import '../../home/skill_map_provider.dart';
import '../../home/user_setting_view_provider.dart';

class SignUpViewModel {
  BuildContext context;
  SignUpViewModel({required this.context});

  ///ページ遷移の関数
  void backButtonFUnc() {
    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
    int preIndex = signUpViewProvider.pageIndex - 1;
    if (preIndex < 0 || preIndex >= 1) {
      RouteOptions.pagePushToHome();
    } else {
      signUpViewProvider.onChangeSignUpPage(preIndex);
    }
  }

  ///メールチェック
  void emailCheck() {
    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
    bool isEmail = signUpViewProvider.signUpEmailCheck(signUpViewProvider.emailController.text);
    if (isEmail) {
      signUpViewProvider.onChangeSignUpPage(1);
      signUpViewProvider.signUpErrorReset();
    }
  }

  ///登録始まる
  Future<void> signUpStart() async {
    Future<void> loadingPopView() {
      return showDialog<void>(
        barrierDismissible: false,
        barrierColor: barrierColor,
        context: context,
        builder: (BuildContext context) {
          return LoadingAnimationWidget.inkDrop(color: normalBgColor, size: 35);
        },
      );
    }

    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();

    String email = signUpViewProvider.emailController.text;
    String password = signUpViewProvider.pwdController.text;

    print("Email $email Pwd $password");

    loadingPopView();

    // String signUpResult = await signUp(email, password);
    await Future.delayed(const Duration(seconds: 1));
    RouteOptions.pagePop();
    signUpViewProvider.onChangeSignUpPage(2);
  }

  ///firebaseServer、MysqlServer登録
  ///email：メールアドレス，password：パスワード
  Future<void> signUp(String email, String password) async {
    String signUpResult = "";
    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();
    String firebaseSignUpResult = await FirebaseSerivce().firebaseSignUp(email, password);

    if (firebaseSignUpResult.contains("sucess:")) {
      String tempSignedUID = firebaseSignUpResult.substring(("sucess:").length);

      ///Firebase登録したらSQLにユーザデータ作成する
      await UserService().sqlSignUp(tempSignedUID, email, password).then((isMySqlSignUpSucess) async {
        if (isMySqlSignUpSucess) {
          ///FirebaseからUID取得する
          signUpResult = firebaseSignUpResult;

          ///登録結果画面を更新する（UID）
          signUpViewProvider.signUpResultChange(signUpResult);

          ///名前更新するよう（名前輸入あれば）
          await updateUserData();

          ///画面遷移
          signUpViewProvider.onChangeSignUpPage(2);

          return;
        } else {
          signUpResult = "mysql-error";
        }
      });
    } else {
      signUpResult = firebaseSignUpResult;
    }

    ///登録結果画面を更新する（エラーメッセージ）
    signUpViewProvider.signUpResultChange(signUpResult);
  }

  ///ユーザデータ更新する
  Future<void> updateUserData() async {
    SkillMapProvider skillMapProvider = context.read<SkillMapProvider>();
    UserSettingViewProvider userSettingViewProvider = context.read<UserSettingViewProvider>();
    SignUpViewProvider signUpViewProvider = context.read<SignUpViewProvider>();

    UpdateUser updateData = UpdateUser.update(
      uid: signUpViewProvider.signedUID,
      name: userSettingViewProvider.nameInput.text,
      job: userSettingViewProvider.jobInput.text,
      introduction: userSettingViewProvider.introductionInput.text,
      mainSkills: skillMapProvider.haveSkillList,
      wantSkills: skillMapProvider.wantSkillList,
    );

    print(
        "name : ${userSettingViewProvider.nameInput.text} job : ${userSettingViewProvider.jobInput.text} introduction : ${userSettingViewProvider.introductionInput.text}");
    print("haveSkillList : ${skillMapProvider.haveSkillList} wantSkillList : ${skillMapProvider.wantSkillList}");
    print("updateData $updateData");
    // await UserService().sqlUpdateUserData(signUpViewProvider.signedUID, updateData).then(
    //   (isSucess) async {
    //     if (isSucess) {
    //       signUpViewProvider.onChangeSignUpPage(3);
    //     }
    //   },
    // );

    signUpViewProvider.onChangeSignUpPage(3);
  }
}
