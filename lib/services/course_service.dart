import '../global.dart';
import '../models/course_model.dart';
import 'api_client.dart';

class CourseService extends ApiClient {
  CourseService() : super(overrideIp: "$ip:$port/courses");

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
}
