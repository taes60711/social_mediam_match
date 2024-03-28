import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'services/db_service.dart';

class CourseState extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<CourseModel> courseData = [];
  List<CourseModel> topCourseData = [];
  bool isFirstLoading = false, isTopFirstLoading = false;
  int carouselPageIndex = 0;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  CourseModel? choicedCourse;

  void choicedPage(CourseModel c) {
    choicedCourse = c;
    notifyListeners();
  }

  void carouselPageOnchange(int index) {
    carouselPageIndex = index;
    notifyListeners();
  }

  Future<void> getCourseData(int type, {required bool isFirstSearch}) async {
    try {
      List<CourseModel> tempCourseData = [];
      if (isFirstSearch) {
        isFirstLoading = true;
        isTopFirstLoading = true;
        Future.delayed(Duration.zero).then((value) => notifyListeners());
        tempCourseData = await _dbService.getCoursesByType(type, isFirst: isFirstSearch);
      } else {
        tempCourseData = await _dbService.getCoursesByType(type);
      }
      if (type == 0) {
        tempCourseData.forEach((e) {
          courseData = [...courseData, e];
        });
        if (isFirstLoading) {
          isFirstLoading = false;
        }
      } else {
        tempCourseData.forEach((e) {
          topCourseData = [...topCourseData, e];
        });
        if (isTopFirstLoading) {
          isTopFirstLoading = false;
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
