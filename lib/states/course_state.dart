import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/course_model.dart';
import '../global.dart';
import '../models/user_model.dart';
import 'services/db_service.dart';
import 'package:http/http.dart' as http;

class CourseState extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<CourseModel> courseData = [];
  List<CourseModel> topCourseData = [];
  bool isFirstLoading = false, isAddDataLoading = false, isReLoading = false, isTopFirstLoading = false;

  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  CourseModel? choicedCourse;

  //サーバーアドレス
  String url = "http://$ip:$port";
  List<Map<String, dynamic>> skillList = [];
  List<String> choicedskillList = [];
  Future<bool> getSkillListData({LoginUser? userData}) async {
    bool result = false;
    var uri = Uri.parse('$url/skill/getList');
    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        List<dynamic> jsonData = json.decode(response.body);
        for (var e in jsonData) {
          skillList.add({"name": e['name'], "ischoiced": false});
          notifyListeners();
        }
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  void choiceSkill(int index) {
    skillList[index]['ischoiced'] = !skillList[index]['ischoiced'];
    if (skillList[index]['ischoiced']) {
      choicedskillList.add(skillList[index]['name']);
    } else {
      choicedskillList.remove(skillList[index]['name']);
    }
    notifyListeners();
  }

  bool isPublic = true;
  void isPublicOnChange() {
    isPublic = !isPublic;
    notifyListeners();
  }

  List<CourseChapterInfo> chapters = [];
  void addChapter() {
    chapters.add(CourseChapterInfo(chapter: chapters.length + 1, content: []));
    print("addChapter");
    notifyListeners();
  }

  void deleteChapter(int index) {
    chapters.remove(chapters[index]);
    print("deleteChapter");
    notifyListeners();
  }

  void addChapterContent(int index, String content) {
    chapters[index].content.add(content);
    print("chapterContents");
    notifyListeners();
  }

  void deleteChapterContent(int chapterIndex, int contentIndex) {
    chapters[chapterIndex].content.remove(chapters[chapterIndex].content[contentIndex]);
    print("deleteChapterContent");
    notifyListeners();
  }

  String needLevel = '1';
  String type = '1';
  void needLevelChange(String value, String wantChangeValue) {
    if (wantChangeValue == "needLevel")
      needLevel = value;
    else if (wantChangeValue == "type") {
      type = value;
    }
    notifyListeners();
  }

  double startScrollPosition = -1;
  void getStartScrollPos(double pos) {
    startScrollPosition = pos;
    notifyListeners();
  }

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

  Future<bool> createCourse({required CourseCreateModel createCourseData}) async {
    bool createResult = await _dbService.createCourse(createCourseData: createCourseData);
    return createResult;
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
