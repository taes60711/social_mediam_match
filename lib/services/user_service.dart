// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/route_options.dart';
import 'package:social_mediam_match/services/api_client.dart';

import '../models/user_model.dart';

///ユーザAPIサービス
class UserService extends ApiClient {
  UserService() : super(overrideIp: "$ip:$port/user");

  ///MARK: ユーザのデータ取得
  ///Param,
  ///loginedUserUID: FirebaseログインしたユーザUID
  Future<LoginUser> requestGetUserData(String loginedUserUID) async {
    LoginUser userdata = LoginUser(uid: "-1");
    try {
      String responseData = await apiGet('/$loginedUserUID');
      print("Logined User Data :  $responseData");

      userdata = await handleResponse<LoginUser>(
        responseData,
        model: LoginUser.toModel,
      );
    } catch (e) {
      onRequestFailed(onFailedFunc: () => RouteOptions.pagePushToHome());
    }

    return userdata;
  }

  ///MARK: ログインのタイム更新する
  ///Param,
  ///userUID: ログインしたユーザUID
  Future<void> sqlUpdateUserLoginLastTime(String userUID) async {
    String lastLoginTime = DateTime.now().toUtc().toIso8601String();
    Map<String, dynamic> body = {
      'uid': userUID,
      "lastlogin": lastLoginTime,
    };

    String responseData = await apiPush('/updateLoginTime/$userUID', body: body);
    await handleResponse(responseData);

    print("updateUserLoginLastTime : $responseData");
  }

  ///MARK: スマホのToken更新する
  ///Param,
  ///userUID: ログインしたユーザUID, token : ユーザスマホのToken
  Future<void> sqlUpdateUserToken(String userUID, String token) async {
    Map<String, dynamic> body = {
      'uid': userUID,
      "token": token,
    };

    String responseData = await apiPush('/updateToken/$userUID', body: body);
    await handleResponse(responseData);

    print("updateUserToken : $responseData");
  }

  //MARK: MYSQLにデータを作成する
  //param
  //uid：firebaseからアカウントid,　email：メールアドレス，password：パスワード
  Future<bool> sqlSignUp(String uid, String email, String password) async {
    var sha256Password = sha256.convert(utf8.encode(password));
    print("Digest as hex password: $sha256Password");

    Map<String, dynamic> body = {
      'uid': uid,
      "email": email,
      "password": "$sha256Password",
      "isEmailVerified": false,
    };
    String responseData = await apiPush('/signUp', body: body);

    print("signUpUser : $responseData");

    return responseData != "null" ? true : false;
  }

  ///MARK: データを更新する
  ///Param,
  ///uid：ログインしたユーザUID,　updateData：ユーザの個人情報
  Future<bool> sqlUpdateUserData(String uid, UpdateUser updateData) async {
    Map<String, dynamic> body = updateData.toMap();

    String responseData = await apiPush('/update/$uid', body: body);
    await handleResponse(responseData);

    print("updateUserData : $responseData");

    return responseData != "null" ? true : false;
  }
}
