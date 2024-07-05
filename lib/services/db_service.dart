import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:social_mediam_match/models/course_model.dart';

import '../../global.dart';

class DBService {
  String url = "http://$ip:$port";

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
}
