// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:social_mediam_match/global.dart';

import 'package:social_mediam_match/services/api_client.dart';

import '../models/user_model.dart';

///ユーザAPIサービス
class UserService extends ApiClient {
  UserService() : super(overrideIp: "$ip:$port/user");

  Future<List<ProfileData>> getADUserData(
    int size, {
    required String userUid,
  }) async {
    List<ProfileData> users = [];

    try {
      Map<String, dynamic> params = {
        'size': '$size',
        'userUid': userUid,
      };

      String responseData = await apiGet('/getADUserData', paramters: params);

      print("getADUserData usersData: $responseData");

      users = await handleResponse<ProfileData>(
        responseData,
        isList: true,
        model: ProfileData.toModel,
      );
    } catch (e) {
      onRequestFailed();
    }
    return users;
  }

  Future<List<ProfileData>> getAllUserData(int page, int size,
      {required String userUid, required List<String> filterSkill}) async {
    List<ProfileData> users = [];

    try {
      Map<String, dynamic> params = {
        'page': '$page',
        'size': '$size',
        'userUid': userUid,
        'skillName': filterSkill,
      };

      String responseData = await apiGet('/getDataBySkillFilter', paramters: params);

      print("getAllUserData usersData: $responseData");

      users = await handleResponse<ProfileData>(
        responseData,
        isList: true,
        model: ProfileData.toModel,
      );
    } catch (e) {
      onRequestFailed();
    }
    return users;
  }

  Future<List<ProfileData>> requestUserDataByNamePart(int page, int size, {required String userName}) async {
    List<ProfileData> users = [];

    try {
      Map<String, dynamic> params = {
        'page': '$page',
        'size': '$size',
        'userName': userName,
      };

      String responseData = await apiGet('/getDataByPartName', paramters: params);

      print("requestUserDataByNamePart usersData: $responseData");

      users = await handleResponse<ProfileData>(
        responseData,
        isList: true,
        model: ProfileData.toModel,
      );
    } catch (e) {
      onRequestFailed();
    }
    return users;
  }

  ///MARK: ユーザのデータ取得
  ///Param,
  ///loginedUserUID: FirebaseログインしたユーザUID
  Future<ProfileData> requestGetUserData(String loginedUserUID) async {
    ProfileData userdata = ProfileData(uid: "-1");
    try {
      String responseData = await apiGet('/$loginedUserUID');

      print("Logined User Data :  $responseData");

      userdata = await handleResponse<ProfileData>(
        responseData,
        model: ProfileData.toModel,
      );
    } catch (e) {
      onRequestFailed();
    }

    return userdata;
  }

  Future<ProfileData> login(String email, String password) async {
    ProfileData userdata = ProfileData(uid: "-1");
    var sha256Password = sha256.convert(utf8.encode(password));

    Map<String, dynamic> params = {
      'email': email,
      'password': "$sha256Password",
    };

    String responseData = await apiGet('/login', paramters: params);

    print("Login User Data :  $responseData");

    if (responseData != "") {
      userdata = await handleResponse<ProfileData>(
        responseData,
        model: ProfileData.toModel,
      );
    }

    return userdata;
  }

  ///MARK: ログインのタイム更新する
  ///Param,
  ///userUID: ログインしたユーザUID
  Future<void> updateUserLoginLastTime(String userUID) async {
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
  Future<void> updateUserToken(String userUID, String token) async {
    Map<String, dynamic> body = {
      'uid': userUID,
      "token": token,
    };

    String responseData = await apiPush('/updateToken/$userUID', body: body);
    await handleResponse(responseData);

    print("updateUserToken : $responseData");
  }

  //param
  //email：メールアドレス，password：パスワード
  /// success, emailExist , captchaCodeErr
  Future<String> signUp(
      {required String captchaCode, required String email, required String password, required String name}) async {
    var sha256Password = sha256.convert(utf8.encode(password));
    print("Digest as hex password: $sha256Password");

    Map<String, dynamic> body = {
      "email": email,
      "password": "$sha256Password",
      "name": name,
      "isEmailVerified": true,
    };
    String responseData = await apiPush('/signUp/$captchaCode', body: body);

    print("signUpUser : $responseData");

    return responseData;
  }

  ///MARK: データを更新する
  ///Param,
  ///uid：ログインしたユーザUID,　updateData：ユーザの個人情報
  Future<bool> updateUserData(String uid, UpdateUser updateData) async {
    Map<String, dynamic> body = updateData.toMap();

    String responseData = await apiPush('/update/$uid', body: body);
    await handleResponse(responseData);

    print("updateUserData : $responseData");

    return responseData != "null" ? true : false;
  }

  /// emailType：
  /// "signUp", "resetPwd", "verify"
  Future<String> sendCaptchaMail({required String email}) async {
    Map<String, dynamic> params = {
      "email": email,
      "emailType": "signUp",
    };

    String responseData = await apiGet('/sendCaptchaMail', paramters: params);

    print("sendCaptchaMail : $responseData");

    return responseData;
  }
}
