import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'services/db_service.dart';

class CourseState extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<CourseModel> courseData = [];
  List<CourseModel> topCourseData = [];
  bool isFirstLoading = false, isAddDataLoading = false, isReLoading = false, isTopFirstLoading = false;

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

  Future<void> getCourseData(int type, {required String searchType}) async {
    try {
      List<CourseModel> tempCourseData = [];
      if (searchType == "First") {
        isFirstLoading = true;
        isTopFirstLoading = true;
        Future.delayed(Duration.zero).then((value) => notifyListeners());
        tempCourseData = await _dbService.getCoursesByType(type, isFirst: true);
      } else {
        tempCourseData = await _dbService.getCoursesByType(type);
      }

      if (type == 0) {
        if (searchType == "AddData") {
          tempCourseData.forEach((e) {
            topCourseData = [...topCourseData, e];
          });
          isAddDataLoading = false;
        } else {
          courseData = tempCourseData;
          if (searchType == "First") {
            isFirstLoading = false;
          } else if (searchType == "Reload") {
            isReLoading = false;
          }
        }
      } else {
        topCourseData = tempCourseData;
        if (searchType == "First") {
          isTopFirstLoading = false;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void addData() {
    isAddDataLoading = true;
    notifyListeners();
  }

  void reLoadingPage() {
    isReLoading = true;
    notifyListeners();
  }
}
