import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/strings/account/login_strings.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/components/strings/message_strings/account_message.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/friend_state.dart';
import 'package:social_mediam_match/states/services/db_service.dart';

import '../components/strings/account/sign_up_strings.dart';

class UserState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DBService _dbService = DBService();
  //サーバーアドレス
  String url = "http://$ip:$port/user";
  //ユーザダータ
  LoginUser? userData;
  //ページローディング
  bool isLoading = false;
  //パスワード忘れたページに送信したメッセージ
  String resetPwdError = ResetPwdStatus.NoMessage.value;
  //サインアップステップインデックス
  int signUpIndex = 0;

  //サインアップのインプット
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  //メソッド：サインアップページチェンジ
  //param
  //toSignUpIndex : サインアップのページインデックス
  Future<int> onChangeSignUpPage(int toSignUpIndex) async {
    await Future.delayed(Duration.zero);
    if (toSignUpIndex == 0) {
      signUpErrorReset();
      emailController = TextEditingController();
      pwdController = TextEditingController();
    }
    signUpIndex = toSignUpIndex;
    notifyListeners();
    return signUpIndex;
  }

  //メソッド：アプリ始めるスタート場合は，ユーザーログインがどうか確認する
  void isLoginCheck(FriendState chatListChannel) {
    Stream<String> colsure() {
      return _auth.authStateChanges().map((event) {
        return event != null ? event.uid : "";
      });
    }

    if (userData == null) {
      colsure().listen((String userUID) async {
        if (userUID != "" && !isLoading) {
          isLoading = true;
          notifyListeners();

          //ユーザの資料を取得する
          userData = await _dbService.getUserData(userUID);
          //最後ログインのタイム更新する
          await _dbService.updateLastTime(userUID);
          //チャットルームサーバー繋がる
          chatListChannel.friendListConnect(userUID);
          inspect(userData);

          if (Platform.isAndroid) {
            //取得使用者TOKEN > 通知系統在上架前,先暫時只給安卓使用
            final fcmToken = await FirebaseMessaging.instance.getToken();
            _dbService.updateUserToken(userUID, fcmToken!);
          }

          isLoading = false;
          notifyListeners();
        }
      });
    }
  }

  //ログインのエラーメッセージ
  String loginError = LoginError().noError;
  //メソッド：ログイン
  //param
  //email：メールアドレス，password：パスワード
  Future<bool> signIn(String email, String password) async {
    bool isSucess = false;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      isSucess = true;
    } on FirebaseAuthException catch (e) {
      print("signIn error ${e.code}");
      switch (e.code) {
        case "invalid-credential":
          loginError = LoginError().emailorPwdError;
          break;
        case "invalid-email":
          loginError = LoginError().emailFormatError;
          break;
        case "channel-error":
          loginError = "channel-error";
      }
      notifyListeners();
    }
    return isSucess;
  }

  //Firebaseで登録したユーザUID
  String signUpedUserUID = "";
  //サインアップのエラーメッセージ
  String signError = SignUpError().noError;
  //メソッド：登録
  //param
  //email：メールアドレス，password：パスワード
  Future<dynamic> signUp(String email, String password) async {
    bool isSucess = false;
    try {
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then(
        (UserCredential value) async {
          print("firebase SiginUp Success:${value.user!.uid}");

          bool isMysqlSignUpSucess = await _dbService.signUpUser(value.user!.uid, email, password);

          if (isMysqlSignUpSucess) {
            isSucess = true;
            print("Mysql SignUp Sucess");
            signUpedUserUID = value.user!.uid;
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      print("SignUp error ${e.code}");
      switch (e.code) {
        case "invalid-email":
          signError = SignUpError().emailFormatError;
          break;
        case "weak-password":
          signError = SignUpError().pwdWeakError;
          break;
        case "channel-error":
          signError = "channel-error";
          break;
      }

      notifyListeners();
    }
    return isSucess;
  }

  //メソッド：メールアドレスかどうか確認
  //param
  //email：メールアドレス
  bool signUpEmailCheck(String email) {
    bool isEmail = true;
    if (!email.contains("@")) {
      signError = SignUpError().emailFormatError;
      notifyListeners();
      isEmail = false;
    }
    return isEmail;
  }

  void signUpErrorReset() {
    signError = SignUpError().noError;
    notifyListeners();
  }

  //メソッド：ログアウト
  Future<void> signOut(FriendState chatListChannel) async {
    await _auth.signOut().then((value) {
      chatListChannel.closefriendList();
      userData = null;
      notifyListeners();
    });
  }

  //メソッド：パスワード忘れた場合，パスワードがメール送ってリセット
  //param
  //email：ユーザ登録のメールアドレス
  Future<void> reSetPwd(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Email Sended");

      resetPwdError = ResetPwdStatus.Success.value;
    } catch (e) {
      resetPwdError = ResetPwdStatus.Error.value;
      print("Email Error $resetPwdError");
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String uid, UpdateUser updateData) async {
    bool isSucess = false;
    try {
      isSucess = await _dbService.updateUserData(uid, updateData);
      if (isSucess) {
        userData = await _dbService.getUserData(uid);
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
    return isSucess;
  }
}
