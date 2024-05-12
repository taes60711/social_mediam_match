import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/course_model.dart';
import '../models/user_model.dart';
import 'services/db_service.dart';

class CourseState extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<CourseModel> courseData = [];
  List<CourseModel> topCourseData = [];
  bool isFirstLoading = false, isAddDataLoading = false, isReLoading = false, isTopFirstLoading = false;

  int carouselPageIndex = 0;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  CourseModel? choicedCourse;

  bool floatButtonIsVisiable = false;
  void floatButtonVisiableChange(double posheight) {
    if (posheight < 40) {
      if (floatButtonIsVisiable) {
        floatButtonIsVisiable = false;
        notifyListeners();
      }
    } else {
      if (!floatButtonIsVisiable) {
        floatButtonIsVisiable = true;
        notifyListeners();
      }
    }
  }

  String endDrawerType = "";
  LoginUser? otherUser;
  void openEndDrawer(String type, {LoginUser? user, CourseModel? course}) {
    endDrawerType = type;
    if (type == "userDetail") {
      otherUser = user;
    } else {
      choicedCourse = course;
    }
    notifyListeners();
  }

  Future<void> getAllCourseData({required String searchType}) async {
    try {
      List<CourseModel> tempCourseData = [];
      if (searchType == "AddData") {
        tempCourseData = await _dbService.getAllCourses();
      } else {
        if (searchType == "First") {
          isFirstLoading = true;
          Future.delayed(Duration.zero).then((value) => notifyListeners());
        }
        tempCourseData = await _dbService.getAllCourses(isFirst: true);
      }

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

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCourseDatabyType(int type, {required String searchType}) async {
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
