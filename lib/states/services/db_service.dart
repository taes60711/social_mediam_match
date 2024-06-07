import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
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
  int size = 8;
  String url = "http://$ip:$port";

  searchStatus courseAddedMemberServerInfo = searchStatus();
  Future<List<AddedCourseMemberModel>> getCourseAddedMember(int courseId, {bool? isFirst}) async {
    String branch = "courses";

    if (isFirst != null) {
      courseAddedMemberServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getCourseMember/$courseId?page=${courseAddedMemberServerInfo.pageNumber}&size=5';

    final uri = Uri.parse(searchUrl);
    List<AddedCourseMemberModel> allAddedMember = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allAddedMember = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
          return AddedCourseMemberModel.toMap(e);
        }).toList();
        inspect(allAddedMember);
        courseAddedMemberServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allAddedMember;
  }

  Future<bool> deleteUserFromCourse({required int courseId, required String userUID}) async {
    String branch = "courses";
    String searchUrl = '$url/$branch/deleteUserFromCourse';

    bool isSuccess = false;

    final uri = Uri.parse(searchUrl);
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = jsonEncode({'courseId': courseId, 'memberUid': userUID});

    try {
      var response = await http.put(uri, headers: headers, body: body);
      if (response.statusCode != 404) {
        isSuccess = true;
      }
    } catch (e) {}
    print("deleteUserFromCourse result : ${isSuccess}");
    return isSuccess;
  }

  Future<bool> updateAddedUserStatus({required int courseId, required String userUID}) async {
    String branch = "courses";
    String searchUrl = '$url/$branch/updateAddedUserStatus';

    bool isSuccess = false;

    final uri = Uri.parse(searchUrl);
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = jsonEncode({'courseId': courseId, 'memberUid': userUID});

    try {
      var response = await http.put(uri, headers: headers, body: body);
      if (response.statusCode != 404) {
        isSuccess = true;
      }
    } catch (e) {}
    print("updateAddedUserStatus result : ${isSuccess}");
    return isSuccess;
  }

  Future<bool> isAddedCourse({required int courseId, required String userUID}) async {
    String branch = "courses";
    String searchUrl = '$url/$branch/getIsAddCourse?courseId=$courseId&userId=$userUID';
    bool isAdded = false;
    final uri = Uri.parse(searchUrl);

    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        isAdded = response.body == 'true' ? true : false;
      }
    } catch (e) {
      print(e);
    }
    return isAdded;
  }

  Future<bool> userAddCourseRequest({required int courseId, required String userUID}) async {
    String branch = "courses";
    String searchUrl = '$url/$branch/addCourse';

    bool isSuccess = false;

    final uri = Uri.parse(searchUrl);
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = jsonEncode({'courseId': courseId, 'memberUid': userUID});

    try {
      var response = await http.put(uri, headers: headers, body: body);
      if (response.statusCode != 404) {
        isSuccess = true;
      }
    } catch (e) {}
    print("userAddCourseRequest result : ${isSuccess}");
    return isSuccess;
  }

  Future<bool> updateCourse({required int courseId, required CourseCreateModel courseUpdateData}) async {
    String branch = "courses";
    String searchUrl = '$url/$branch/updateCourse/$courseId';

    bool isSuccess = false;

    final uri = Uri.parse(searchUrl);
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = courseUpdateData.courseCreatetoJson();

    try {
      var response = await http.put(uri, headers: headers, body: body);
      if (response.statusCode != 404) {
        isSuccess = true;
      }
    } catch (e) {}
    print("update Course result : ${isSuccess}");
    return isSuccess;
  }

  Future<bool> createCourse({required CourseCreateModel createCourseData}) async {
    String branch = "courses";
    String searchUrl = '$url/$branch/createCourse';

    bool isSuccess = false;

    final uri = Uri.parse(searchUrl);
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = createCourseData.courseCreatetoJson();

    try {
      await http.put(uri, headers: headers, body: body);
      isSuccess = true;
    } catch (e) {}
    print("create Course result : ${isSuccess}");
    return isSuccess;
  }

  searchStatus allCoursesServerInfo = searchStatus();
  Future<List<CourseModel>> getAllCourses({bool? isFirst}) async {
    String branch = "courses";

    if (isFirst != null) {
      allCoursesServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getAllCourses?page=${allCoursesServerInfo.pageNumber}&size=$size';
    final uri = Uri.parse(searchUrl);
    List<CourseModel> allCouserData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allCouserData = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
          return CourseModel.toMap(e);
        }).toList();
        inspect(allCouserData);
        allCoursesServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allCouserData;
  }

  searchStatus addCoursesServerInfo = searchStatus();
  Future<List<CourseModel>> getAddedCourses(String userId, {bool? isFirst}) async {
    String branch = "courses";

    if (isFirst != null) {
      addCoursesServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getAddedCourses/$userId?page=${addCoursesServerInfo.pageNumber}&size=$size';
    final uri = Uri.parse(searchUrl);
    List<CourseModel> allCouserData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        print(response.body);
        allCouserData = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
          return CourseModel.toMap(e);
        }).toList();
        inspect(allCouserData);
        addCoursesServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allCouserData;
  }

  searchStatus coursesByUserIdServerInfo = searchStatus();
  Future<List<CourseModel>> getCoursesByUserId(String userId, {bool? isFirst}) async {
    String branch = "courses";

    if (isFirst != null) {
      coursesByUserIdServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getCoursesByUserId/$userId?page=${coursesByUserIdServerInfo.pageNumber}&size=$size';
    final uri = Uri.parse(searchUrl);
    List<CourseModel> allCouserData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allCouserData = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
          return CourseModel.toMap(e);
        }).toList();
        inspect(allCouserData);
        coursesServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allCouserData;
  }

  searchStatus coursesServerInfo = searchStatus();
  Future<List<CourseModel>> getCoursesByType(int type, {bool? isFirst}) async {
    String branch = "courses";

    if (isFirst != null) {
      coursesServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getCoursesByType/$type?page=${coursesServerInfo.pageNumber}&size=$size';
    final uri = Uri.parse(searchUrl);
    List<CourseModel> allCouserData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allCouserData = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
          return CourseModel.toMap(e);
        }).toList();
        inspect(allCouserData);
        coursesServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allCouserData;
  }

  Future<void> updatePostComment(int postId, String mainMessage) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/updatePostComment/$postId';
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = UpdateCommentPostModel(id: postId, message: mainMessage).updatePost();
    final uri = Uri.parse(searchUrl);
    try {
      var response = await http.put(uri, headers: headers, body: body);
      if (response.statusCode != 404) {
        print("update sucess");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePostComment(int uId) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/deletePostComment/$uId';

    final uri = Uri.parse(searchUrl);
    try {
      var response = await http.put(uri);
      if (response.statusCode != 404) {
        print("delete sucess");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<int> createPostComment(int postUId, String uid, String message) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/createPostComment';

    final uri = Uri.parse(searchUrl);
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = jsonEncode({"postId": postUId, "userUid": uid, "message": message});

    Response result = await http.put(uri, headers: headers, body: body);
    int index = int.parse(result.body);
    return index;
  }

  searchStatus postCommentServerInfo = searchStatus();
  Future<List<PostCommentModel>> getPostCommentData(int postId, {bool? isFirst}) async {
    String branch = "posts";

    if (isFirst != null) {
      postCommentServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getPostComment/$postId?page=${postCommentServerInfo.pageNumber}&size=$size';

    final uri = Uri.parse(searchUrl);
    List<PostCommentModel> allpostData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allpostData = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
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

  Future<void> updatePost(int postId, String mainMessage) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/update/$postId';
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = UpdatePostModel(id: postId, mainMessage: mainMessage).updatePost();
    final uri = Uri.parse(searchUrl);
    try {
      var response = await http.put(uri, headers: headers, body: body);
      if (response.statusCode != 404) {
        print("updatePost update sucess");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePostGood(int postId, {String? userUID}) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/updatePostGood/$postId';
    Map<String, String> headers = {'content-type': 'application/json'};
    final uri = Uri.parse(searchUrl);
    var response;
    try {
      if (userUID != null) {
        String body = jsonEncode({"goodedUserUID": userUID});
        response = await http.put(uri, headers: headers, body: body);
        print("Good");
      } else {
        String body = jsonEncode({"": ""});
        response = await http.put(uri, headers: headers, body: body);
        print("takeBackGood");
      }
      inspect(response);
      if (response.statusCode != 404) {
        print("updatePostGood sucess");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkIsPostGood(int postId, String userUID) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/checkIsPostGood/$postId/$userUID';
    bool ischeck = false;
    final uri = Uri.parse(searchUrl);
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        print("checkIsPostGood: ${response.body}");
        if (response.body == "true") {
          ischeck = true;
        }
        print("checkIsPostGood");
      }
    } catch (e) {
      print(e);
    }
    return ischeck;
  }

  Future<void> moveToPost(int postId) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/moveToPost/$postId';

    final uri = Uri.parse(searchUrl);
    try {
      var response = await http.put(uri);
      if (response.statusCode != 404) {
        print("moveToPost update sucess");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(int postId) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/delete/$postId';

    final uri = Uri.parse(searchUrl);
    try {
      var response = await http.put(uri);
      if (response.statusCode != 404) {
        print("delete sucess");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createPost(String uid, String title, String message, int type) async {
    String branch = "posts";
    String searchUrl = '$url/$branch/createPost';

    final uri = Uri.parse(searchUrl);

    Map<String, String> headers = {'content-type': 'application/json'};
    String body = CreatePostModel(createdByUId: uid, title: title, mainMessage: message, type: type).createPost();

    await http.put(uri, headers: headers, body: body).then((_) {
      print("MySql Post Create :${_.body}");
    });
  }

  searchStatus postServerInfo = searchStatus();
  Future<List<PostModel>> getPostData({bool? isFirst}) async {
    String branch = "posts";

    if (isFirst != null) {
      postServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getAll?page=${postServerInfo.pageNumber}&size=$size';
    final uri = Uri.parse(searchUrl);
    List<PostModel> allpostData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allpostData = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
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

  searchStatus postByTextFilterServerInfo = searchStatus();
  Future<List<PostModel>> getPostByTextFilter({required String inputedText, bool? isFirst}) async {
    String branch = "posts";

    if (isFirst != null) {
      postByTextFilterServerInfo.pageNumber = 0;
    }

    String searchUrl =
        '$url/$branch/getPostByTextFilter?inputedText=$inputedText&page=${postByTextFilterServerInfo.pageNumber}&size=$size';
    final uri = Uri.parse(searchUrl);
    List<PostModel> allpostData = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allpostData = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
          print(e);
          return PostModel.toMap(e);
        }).toList();

        inspect(allpostData);
        postByTextFilterServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allpostData;
  }

  searchStatus postByUserIdServerInfo = searchStatus();
  Future<List<PostModel>> getPostDataByUID(LoginUser userData, {bool? isFirst}) async {
    String branch = "posts";

    if (isFirst != null) {
      postByUserIdServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getPostsByUser/${userData.uid}?page=${postServerInfo.pageNumber}&size=$size';

    final uri = Uri.parse(searchUrl);
    List<PostModel> allpostDataByUID = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allpostDataByUID = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
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

  searchStatus newPostServerInfo = searchStatus();
  Future<List<PostModel>> getNewPosts({bool? isFirst}) async {
    String branch = "posts";

    if (isFirst != null) {
      newPostServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getNewPosts?page=${newPostServerInfo.pageNumber}&size=$size';

    final uri = Uri.parse(searchUrl);
    List<PostModel> allpostnewPosts = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allpostnewPosts = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
          print(e);
          return PostModel.toMap(e);
        }).toList();

        inspect(allpostnewPosts);
        newPostServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allpostnewPosts;
  }

  searchStatus postsByTypeServerInfo = searchStatus();
  Future<List<PostModel>> getPostsByType(int type, {bool? isFirst}) async {
    String branch = "posts";

    if (isFirst != null) {
      postsByTypeServerInfo.pageNumber = 0;
    }

    String searchUrl = '$url/$branch/getPostsByType/$type?page=${postsByTypeServerInfo.pageNumber}&size=$size';

    final uri = Uri.parse(searchUrl);
    List<PostModel> allpostsByType = [];
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        allpostsByType = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((e) {
          print(e);
          return PostModel.toMap(e);
        }).toList();

        inspect(allpostsByType);
        postsByTypeServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }
    return allpostsByType;
  }

  //メソッド：MYSQLにユーザーデータを取得する
  searchStatus alluserServerInfo = searchStatus();
  Future<List<LoginUser>> getAllUserData(
      {String? userUid, required List<String> filterSkill, required bool isFirstSearch}) async {
    String branch = "user";

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
        allUserData = (json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>).map((element) {
          return LoginUser.toModel(element);
        }).toList();
        alluserServerInfo.pageNumber++;
      }
    } catch (e) {
      print(e);
    }

    return allUserData;
  }
}
