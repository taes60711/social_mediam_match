import 'package:flutter/foundation.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'services/db_service.dart';

class CourseState extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<CourseModel> courseData = [];
  bool isFirstLoading = false;

  Future<void> getCourseData({required bool isFirstSearch}) async {
    try {
      List<CourseModel> tempCourseData = [];
      if (isFirstSearch) {
        isFirstLoading = true;
        Future.delayed(Duration.zero).then((value) => notifyListeners());
        tempCourseData = await _dbService.getAllCourses(isFirst: isFirstSearch);
      } else {
        tempCourseData = await _dbService.getAllCourses();
      }

      tempCourseData.forEach((e) {
        courseData = [...courseData, e];
      });
      isFirstLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
