import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../../global.dart';
import '../../models/user_model.dart';

class DBService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String url = "http://$ip:$port";

  Stream<List<dynamic>> getCourseData() {
    final stream = firestore.collection("courses").snapshots();
    inspect(stream.map((e) => e.docs.map((e) => e.data()).toList()));
    return stream.map((e) => e.docs.map((e) => e.data()).toList());
  }

  Stream<List<dynamic>> getPostData() {
    final stream = firestore.collection("posts").snapshots();
    inspect(stream.map((e) => e.docs.map((e) => e.data()).toList()));
    return stream.map((e) => e.docs.map((e) => e.data()).toList());
  }

  //メソッド：MYSQLにユーザーデータを取得する
  int pageNumber = 0;
  Future<List<LoginUser>> getAllUserData(String userUid, {required List<String> filterSkill, required bool isFirstSearch}) async {
    String branch = "user";
    int size = 5;

    if (isFirstSearch) {
      pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getDataBySkillFilter?userUid=$userUid&page=$pageNumber&size=$size';
    if (filterSkill.isNotEmpty) {
      String searchkey = "";
      for (var element in filterSkill) {
        searchkey += "$element,";
      }
      searchUrl += "&skillName=$searchkey";
    }

    final uri = Uri.parse(searchUrl);
    List<LoginUser> allUserData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allUserData = (json.decode(response.body)['content'] as List<dynamic>).map((element) {
          return LoginUser.jsonToModel(element);
        }).toList();
        pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allUserData;
  }

  Future<LoginUser?> getUserData(String uid) async {
    String branch = "user";
    final uri = Uri.parse('$url/$branch/$uid');
    LoginUser? userdata;
    try {
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = UpdateUser.lastTimupdate(uid: uid, lastLogin: DateTime.now().toIso8601String()).updateLastLoginTimeJson();

      //ユーザログインのタイム更新する
      await http
          .put(
            Uri.parse('$url/$branch/updateLoginTime/$uid'),
            headers: headers,
            body: body,
          )
          .then((_) => print("MySql LoginTimeUpdate:${_.body}"))
          .then((value) async {
        //ユーザのデータ取得
        var response = await http.get(uri);

        if (response.statusCode != 404) {
          print("userData :  ${response.body}");
          userdata = LoginUser.jsonToModel(json.decode(response.body));
        }
      });
    } catch (e) {
      print(e);
    }
    return userdata;
  }

  //メソッド：MYSQLにユーザーデータを作成する
  //param
  //uid：firebaseからアカウントid,　email：メールアドレス，password：パスワード
  Future<bool> signUpUser(String uid, String email, String password) async {
    bool isSucess = false;
    String branch = "user";
    try {
      final uri = Uri.parse('$url/$branch/signUp');
      Map<String, String> headers = {'content-type': 'application/json'};

      var digest = sha256.convert(utf8.encode(password));
      print("Digest as hex password: $digest");

      UpdateUser signedUpUserData = UpdateUser.signUp(
        uid: uid,
        email: email,
        password: "$digest",
        isEmailVerified: false,
      );

      String body = jsonEncode(signedUpUserData);

      await http.put(uri, headers: headers, body: body).then((_) => print("MySql SiginUp Success:${_.body}"));
      isSucess = true;
    } catch (e) {
      print(e);
    }
    return isSucess;
  }

  //メソッド：MYSQLにユーザーデータを更新する
  //param
  //uid：firebaseからアカウントid,　updateData：ユーザの個人情報
  Future<bool> updateUserData(String uid, UpdateUser updateData) async {
    bool isSucess = false;
    String branch = "user";
    try {
      final uri = Uri.parse('$url/$branch/update/$uid');
      Map<String, String> headers = {'content-type': 'application/json'};
      inspect(updateData);
      String body = jsonEncode(updateData);
      await http.put(uri, headers: headers, body: body).then(
            (_) => print("MySql Update Success:${_.body}"),
          );
      isSucess = true;
    } catch (e) {
      print(e);
    }
    return isSucess;
  }
}
