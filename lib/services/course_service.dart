import '../global.dart';
import '../models/course_model.dart';
import 'api_client.dart';

class CourseService extends ApiClient {
  CourseService() : super(overrideIp: "$ip:$port/courses");

  Future<bool> createOrUpdateCourse({
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

    String url = "/createCourse";
    if (courseId != null) {
      url = "/updateCourse/$courseId";
    }
    String responseData = await apiPush(url, body: body);

    print("createCourse $responseData");

    return responseData != "null" ? true : false;
  }

  /// 全てコース
  Future<List<CourseModel>> getAllCourses(int page, int size) async {
    List<CourseModel> requestAllCourseData = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getAllCourses', paramters: paramters);

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

  /// フィルターしたコース(まだ使っていない)
  Future<List<CourseModel>> getCoursesByFilter(int page, int size, int type) async {
    List<CourseModel> requestFilteredCourseData = [];

    Map<String, dynamic> paramters = {
      'page': '$page',
      'size': '$size',
    };

    try {
      String responseData = await apiGet('/getCoursesByType/$type', paramters: paramters);

      requestFilteredCourseData = await handleResponse<CourseModel>(
        responseData,
        model: CourseModel.toMap,
        isList: true,
      );
    } catch (e) {
      onRequestFailed();
    }

    return requestFilteredCourseData;
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

  /// 参加するかどうか確認
  Future<bool> isAddedCourse({required int courseId, required String userUID}) async {
    bool isAdded = false;
    Map<String, dynamic> paramters = {
      'courseId': '$courseId',
      'userId': userUID,
    };
    try {
      String responseData = await apiGet('/getIsAddCourse', paramters: paramters);

      if (responseData == "true") {
        isAdded = true;
      }
    } catch (e) {
      onRequestFailed();
    }

    return isAdded;
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
}
