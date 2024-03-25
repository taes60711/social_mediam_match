import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:social_mediam_match/models/course_model.dart';
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

  searchStatus coursesServerInfo = searchStatus();
  Future<List<CourseModel>> getAllCourses({bool? isFirst}) async {
    String branch = "courses";
    int size = 5;

    String searchUrl = '$url/$branch/getAll?page=${coursesServerInfo.pageNumber}&size=$size';
    final uri = Uri.parse(searchUrl);
    List<CourseModel> allCouserData = [];
    try {
      var response = await http.get(uri);

      if (response.statusCode != 404) {
        allCouserData = (json.decode(utf8.decode(response.bodyBytes))['content'] as List<dynamic>).map((e) {
          print(e);
          return CourseModel.toMap(e);
        }).toList();
      }
    } catch (e) {
      print(e);
    }
    return allCouserData;
  }

  Future<void> createPostComment(int postUId, String uid, String message) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/createPostComment';

    final uri = Uri.parse(searchUrl);
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = jsonEncode({"postId": postUId, "userUid": uid, "message": message});

    await http.put(uri, headers: headers, body: body).then((_) => print("MySql Post Create Success:${_.body}"));
  }

  searchStatus postCommentServerInfo = searchStatus();
  Future<List<PostCommentModel>> getPostCommentData(int postId, {bool? isFirst}) async {
    String branch = "posts";
    int size = 5;

    if (isFirst != null) {
      postCommentServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getPostComment/$postId?page=${postCommentServerInfo.pageNumber}&size=$size';

    final uri = Uri.parse(searchUrl);
    List<PostCommentModel> allpostData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allpostData = (json.decode(utf8.decode(response.bodyBytes))['content'] as List<dynamic>).map((e) {
          inspect(e);
          return PostCommentModel.toMap(e);
        }).toList();
        postCommentServerInfo.pageNumber++;
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
    String body = jsonEncode({"createdBy": uid, "mainMessage": message});

    await http.put(uri, headers: headers, body: body).then((_) {
      print("MySql Post Create :${_.body}");
    });
  }

  searchStatus postServerInfo = searchStatus();
  Future<List<PostModel>> getPostData({bool? isFirst}) async {
    String branch = "posts";
    int size = 5;
    if (isFirst != null) {
      postServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getAll?page=${postServerInfo.pageNumber}&size=$size';

    final uri = Uri.parse(searchUrl);
    List<PostModel> allpostData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allpostData = (json.decode(utf8.decode(response.bodyBytes))['content'] as List<dynamic>).map((e) {
          print(e);
          return PostModel.toMap(e);
        }).toList();

        inspect(allpostData);
        postServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allpostData;
  }

  searchStatus postByUserIdServerInfo = searchStatus();
  Future<List<PostModel>> getPostDataByUID(LoginUser userData, {bool? isFirst}) async {
    String branch = "posts";
    int size = 5;
    if (isFirst != null) {
      postByUserIdServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getUserAllPosts/${userData.uid}?page=${postServerInfo.pageNumber}&size=$size';

    final uri = Uri.parse(searchUrl);
    List<PostModel> allpostDataByUID = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allpostDataByUID = (json.decode(utf8.decode(response.bodyBytes))['content'] as List<dynamic>).map((e) {
          print(e);
          return PostModel.toMap(e, userData: userData);
        }).toList();

        inspect(allpostDataByUID);
        postByUserIdServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allpostDataByUID;
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
        // alluserServerInfo.totalPage = json.decode(response.body)["totalPages"];
        allUserData = (json.decode(utf8.decode(response.bodyBytes))['content'] as List<dynamic>).map((element) {
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
        userdata = LoginUser.jsonToModel(json.decode(utf8.decode(response.bodyBytes)));
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
