import '../global.dart';
import '../models/course_model.dart';
import 'api_client.dart';

class CourseService extends ApiClient {
  CourseService() : super(overrideIp: "$ip:$port/courses");

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
}
