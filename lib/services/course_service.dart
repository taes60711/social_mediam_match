import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/services/token_service.dart';
import '../models/course_model.dart';
import 'api_client.dart';

class CourseService extends ApiClient {
  CourseService() : super(overrideBranch: "/courses");

  TokenService tokenService = TokenService();

  ///コース作成・更新
  Future<int> createOrUpdateCourse({
    int? courseId,
    required String createdBy,
    required String title,
    required String needLevel,
    required String content,
    required String beforeNeed,
    required String prStory,
    required List<CourseChapterInfo> chapterList,
    required List<String> courseLearningSkills,
    required String type,
    required bool isPublic,
  }) async {
    Map<String, dynamic> body = {
      'createdBy': createdBy,
      'title': title,
      'needLevel': needLevel,
      'content': content,
      'beforeNeed': beforeNeed,
      'prStory': prStory,
      'courseChapters': chapterList.map((chapter) => chapter.toJson()).toList(),
      'learningkillList': courseLearningSkills,
      'type': type,
      'isPublic': isPublic,
    };

    String postType = "create";

    String url = "/createCourse";
    if (courseId != null) {
      postType = "update";
      url = "/updateCourse/$courseId";
    }

    String token = await tokenService.getToken(userId: createdBy);

    String responseData = await apiPush(url,
        headers: {
          'content-type': 'application/json',
          'X-OneTime-Token': token,
        },
        body: body);

    if (postType == "create") {
      ResponseData response = ResponseData.fromJson(responseData);

      print("createCourse ${response.statusCode}");

      if (response.statusCode != "200") {
        return -1;
      }

      return response.data["courseIndex"];
    } else {
      /// -100 = success ; -101 = fail
      ResponseData response = ResponseData.fromJson(responseData);

      print("updateCourse ${response.statusCode}");

      if (response.statusCode != "200") {
        return -101;
      }

      return -100;
    }
  }

  ///コース削除
  Future<bool> deleteCourse({required String uid, required int courseId}) async {
    String token = await tokenService.getToken(userId: uid);

    String responseData = await apiPush(
      "/deleteCourse/$courseId",
      headers: {
        'content-type': 'application/json',
        'X-OneTime-Token': token,
      },
      body: {},
    );

    ResponseData response = ResponseData.fromJson(responseData);

    print("deleteCourse ${response.statusCode}");

    if (response.statusCode != "200") {
      return false;
    }

    return true;
  }

  /// 全てコース
  Future<List<CourseModel>> getAllCourses(String userUID, int page, int size, {List<String>? skillId, String? namePart}) async {
    List<CourseModel> requestAllCourseData = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    if (namePart != null) {
      paramters['namePart'] = namePart;
    } else if (skillId != null) {
      paramters['skillIds'] = skillId;
    }

    try {
      String responseData = await apiGet('/getAllCourses/$userUID', paramters: paramters);

      requestAllCourseData = await handleResponse<CourseModel>(
        responseData,
        model: CourseModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestAllCourseData;
  }

  /// 参加したコース
  Future<List<CourseModel>> getAddedCourses(int page, int size, String userId) async {
    List<CourseModel> requestAddedCourseData = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getAddedCourses/$userId', paramters: paramters);

      requestAddedCourseData = await handleResponse<CourseModel>(
        responseData,
        model: CourseModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestAddedCourseData;
  }

  /// 作成したコース
  Future<List<CourseModel>> getCreatedCourses(int page, int size, String userId) async {
    List<CourseModel> requestCreatedCourseData = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getCoursesByUserId/$userId', paramters: paramters);

      requestCreatedCourseData = await handleResponse<CourseModel>(
        responseData,
        model: CourseModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestCreatedCourseData;
  }

  /// コースIDでコース内容を取得する
  Future<CourseModel> getCourseBycourseId(String userUID, int courseId) async {
    CourseModel requestAddedCourseData = CourseModel(courseCreateduserInfo: ProfileData());

    Map<String, dynamic> paramters = {
      'id': "$courseId",
    };

    try {
      String responseData = await apiGet('/getCourseByCourseId/$userUID', paramters: paramters);

      requestAddedCourseData = await handleResponse<CourseModel>(
        responseData,
        model: CourseModel.toMap,
      );
      print(requestAddedCourseData);
    } catch (e) {
      onRequestFailed(content: "該分享已被刪除");
    }

    return requestAddedCourseData;
  }

  /// コース管理
  Future<List<AddedCourseMemberModel>> getCourseAddedMember(int page, int size, int courseId) async {
    List<AddedCourseMemberModel> requestCourseAddedMemberData = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getCourseMember/$courseId', paramters: paramters);

      requestCourseAddedMemberData = await handleResponse<AddedCourseMemberModel>(
        responseData,
        model: AddedCourseMemberModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestCourseAddedMemberData;
  }

  /// コースを申請
  Future<bool> signUpCourse({required int courseId, required String userUID}) async {
    Map<String, dynamic> body = {
      "courseId": courseId,
      "memberUid": userUID,
    };

    String responseData = await apiPush("/addCourse", body: body);

    print("signUpCourse $responseData");

    return responseData != "null" ? true : false;
  }

  ///コースが申請したユーザ認める
  Future<bool> updateAddedUserStatus({required int courseId, required String userUID}) async {
    Map<String, dynamic> body = {
      "courseId": courseId,
      "memberUid": userUID,
    };

    String responseData = await apiPush("/updateAddedUserStatus", body: body);

    print("updateAddedUserStatus $responseData");

    return responseData != "null" ? true : false;
  }

  ///コースが申請した、参加してるユーザ削除
  Future<bool> deleteUserFromCourse({required int courseId, required String userUID}) async {
    Map<String, dynamic> body = {
      "courseId": courseId,
      "memberUid": userUID,
    };

    String responseData = await apiPush("/deleteUserFromCourse", body: body);

    print("updateAddedUserStatus $responseData");

    return responseData != "null" ? true : false;
  }

  /// 全てライクしたコース
  Future<List<CourseModel>> getAllLikeCourses(String userUID, int page, int size) async {
    List<LikeCourseModel> requestAllLikeCourseData = [];
    List<CourseModel> retruAllLikeCourseData = [];
    Map<String, dynamic> paramters = {
      'userId': userUID,
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getAllLikeCourses', paramters: paramters);

      print(responseData);

      requestAllLikeCourseData = await handleResponse<LikeCourseModel>(
        responseData,
        model: LikeCourseModel.toMap,
        isList: true,
      );

      retruAllLikeCourseData = requestAllLikeCourseData.map((e) => e.course).toList();
    } catch (e) {
      onRequestFailed();
    }

    return retruAllLikeCourseData;
  }

  /// コースをライクする
  Future<bool> likeCourse({required int courseId, required String userUID}) async {
    String responseData = await apiPush("/addLikeCourse/$userUID/$courseId", body: {});

    print("likeCourse $responseData");

    return responseData == "true" ? true : false;
  }

  /// コースをライクから削除する
  Future<bool> deleteLikeCourse({required int courseId, required String userUID}) async {
    String responseData = await apiPush("/deleteLikeCourse/$userUID/$courseId", body: {});

    print("deleteLikeCourse $responseData");

    return responseData == "true" ? true : false;
  }
}
