import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:social_mediam_match/models/post_model.dart';
import '../../global.dart';
import '../../models/user_model.dart';

class searchStatus {
  int pageNumber;
  int totalPage;
  searchStatus({
    this.pageNumber = 0,
    this.totalPage = 0,
  });
}

class DBService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String url = "http://$ip:$port";

  Stream<List<dynamic>> getCourseData() {
    final stream = firestore.collection("courses").snapshots();
    inspect(stream.map((e) => e.docs.map((e) => e.data()).toList()));
    return stream.map((e) => e.docs.map((e) => e.data()).toList());
  }

  Future<void> createPostComment(int postUId, String uid, String message) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/createPostComment';

    final uri = Uri.parse(searchUrl);
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = jsonEncode({"postId": postUId, "userUid": uid, "message": message});

    await http.put(uri, headers: headers, body: body).then((_) => print("MySql Post Create Success:${_.body}"));
  }

  int postCommentPageNumber = 0;
  Future<List<PostCommentModel>> getPostCommentData(int postId) async {
    String branch = "posts";
    int size = 5;

    String searchUrl = '$url/$branch/getPostComment/$postId?page=$postCommentPageNumber&size=$size';

    final uri = Uri.parse(searchUrl);
    List<PostCommentModel> allpostData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        print(response.body);
        allpostData = (json.decode(response.body)['content'] as List<dynamic>).map((e) {
          inspect(e);
          return PostCommentModel.toMap(e);
        }).toList();
        postCommentPageNumber++;
        inspect(allpostData);
      }
    } catch (e) {
      print(e);
    }
    return allpostData;
  }

  Future<void> createPost(String uid, String message) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/createPost';

    final uri = Uri.parse(searchUrl);

    Map<String, String> headers = {'content-type': 'application/json'};
    String body = jsonEncode({"created_by": uid, "main_message": message});

    await http.put(uri, headers: headers, body: body).then((_) {
      print("MySql Post Create :${_.body}");
    });
  }

  int postPageNumber = 0;
  Future<List<PostModel>> getPostData({bool? isFirst}) async {
    String branch = "posts";
    int size = 5;
    if (isFirst != null) {
      postPageNumber = 0;
    }

    String searchUrl = '$url/$branch/getAll?page=$postPageNumber&size=$size';

    final uri = Uri.parse(searchUrl);
    List<PostModel> allpostData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        print(response.body);
        allpostData = (json.decode(response.body)['content'] as List<dynamic>).map((e) {
          return PostModel.toMap(e);
        }).toList();

        inspect(allpostData);
        postPageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allpostData;
  }

  //メソッド：MYSQLにユーザーデータを取得する

  searchStatus alluserServerInfo = searchStatus();
  Future<List<LoginUser>> getAllUserData(
      {String? userUid, required List<String> filterSkill, required bool isFirstSearch}) async {
    String branch = "user";
    int size = 5;

    if (isFirstSearch) {
      alluserServerInfo = searchStatus();
    }

    String searchUrl = '$url/$branch/getDataBySkillFilter?page=${alluserServerInfo.pageNumber}&size=$size';
    if (userUid != null) {
      searchUrl += "&userUid=$userUid";
    }
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
        alluserServerInfo.totalPage = json.decode(response.body)["totalPages"];
        allUserData = (json.decode(response.body)['content'] as List<dynamic>).map((element) {
          return LoginUser.jsonToModel(element);
        }).toList();
        alluserServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }

    return allUserData;
  }

  //ユーザログインのToken更新する
  Future<void> updateUserToken(String uid, String token) async {
    String branch = "user";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = UpdateUser.updateToken(uid: uid, token: token).updateupdateTokenJson();
    await http
        .put(Uri.parse('$url/$branch/updateToken/$uid'), headers: headers, body: body)
        .then((_) => print("MySql Login:${_.body}"));
  }

  //ユーザログインのタイム更新する
  Future<void> updateLastTime(String uid) async {
    String branch = "user";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = UpdateUser.lastTimupdate(uid: uid, lastLogin: DateTime.now().toIso8601String()).updateLastLoginTimeJson();
    await http
        .put(Uri.parse('$url/$branch/updateLoginTime/$uid'), headers: headers, body: body)
        .then((_) => print("MySql LoginTimeUpdate:${_.body}"));
  }

  //ユーザのデータ取得
  Future<LoginUser?> getUserData(String uid) async {
    String branch = "user";
    final uri = Uri.parse('$url/$branch/$uid');
    LoginUser? userdata;
    try {
      var response = await http.get(uri);

      if (response.statusCode != 404) {
        userdata = LoginUser.jsonToModel(json.decode(response.body));
        print("userData :  ");
        inspect(userdata);
      }
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

      String body = signedUpUserData.signUpFormJson();

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
