import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/course_model.dart';
import '../global.dart';
import '../models/user_model.dart';

import 'package:http/http.dart' as http;

import '../services/db_service.dart';

class CourseState extends ChangeNotifier {
  final DBService _dbService = DBService();
  List<CourseModel> courseData = [];
  List<CourseModel> myCourseData = [];
  List<CourseModel> myAddedCourseData = [];
  bool isFirstLoading = false, isAddDataLoading = false, isReLoading = false, isTopFirstLoading = false;

  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  CourseModel? choicedCourse;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController beforeNeedController = TextEditingController();
  void courseDataInsertToView(CourseModel courseData) {
    type = courseData.type.toString();
    needLevel = courseData.needLevel.toString();
    for (var element in courseData.courseLearningSkills) {
      choicedskillList.add(element);
      int choicedSkillIndex = skillList.indexWhere(
        (indexEle) =>
            indexEle ==
            skillList.firstWhere((e) {
              return e['name'] == element;
            }),
      );
      skillList[choicedSkillIndex]['ischoiced'] = true;
    }
    titleController.text = courseData.title;
    contentController.text = courseData.content;
    beforeNeedController.text = courseData.beforeNeed;
    chapters = courseData.chapterList;
    isPublic = courseData.isPublic;
    notifyListeners();
  }

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

  String needLevel = '0';
  String type = '0';
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

  Future<void> deleteUserFromCourse({required int courseId, required String userUId}) async {
    bool isAdded = false;
    try {
      isAdded = await _dbService.deleteUserFromCourse(courseId: courseId, userUID: userUId);
      if (isAdded) {
        int index = addedCourseMembers.indexWhere((element) => element.memberUid == userUId);
        addedCourseMembers.removeAt(index);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> updateAddedUserStatus(addedCourseMembers, {required int courseId, required String userUId}) async {
    bool isAdded = false;
    try {
      isAdded = await _dbService.updateAddedUserStatus(courseId: courseId, userUID: userUId);
      if (isAdded) {
        int index = addedCourseMembers.indexWhere((element) => element.memberUid == userUId);
        addedCourseMembers[index].status = 1;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  List<AddedCourseMemberModel> addedCourseMembers = [];
  Future<void> getAddedCourseMember({required int courseId, bool? isFirst}) async {
    List<AddedCourseMemberModel> resultData = [];
    try {
      resultData = await _dbService.getCourseAddedMember(courseId, isFirst: isFirst);
      addedCourseMembers = resultData;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  bool bIsAddedCourse = true;
  Future<void> isAddedCourse({required int courseId, required String userUId}) async {
    bool isAdded = false;
    try {
      isAdded = await _dbService.isAddedCourse(courseId: courseId, userUID: userUId);
      bIsAddedCourse = isAdded;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<bool> userAddCourseRequest({required int courseId, required String userUId}) async {
    bool isSuccess = false;
    try {
      await _dbService.userAddCourseRequest(courseId: courseId, userUID: userUId);
      isSuccess = true;
      bIsAddedCourse = true;
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return isSuccess;
  }

  Future<bool> updateCourse(
      {required int courseId, required CourseCreateModel courseUpdateData, required LoginUser userData}) async {
    bool createResult = await _dbService.updateCourse(courseId: courseId, courseUpdateData: courseUpdateData);

    return createResult;
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
          courseData = [...courseData, e];
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

  Future<void> getAddedCourses({required String userId, required String searchType}) async {
    try {
      List<CourseModel> tempCourseData = [];
      if (searchType == "AddData") {
        tempCourseData = await _dbService.getAddedCourses(userId);
      } else {
        if (searchType == "First") {
          isFirstLoading = true;
          Future.delayed(Duration.zero).then((value) => notifyListeners());
        }

        tempCourseData = await _dbService.getAddedCourses(userId, isFirst: true);
      }

      if (searchType == "AddData") {
        tempCourseData.forEach((e) {
          myAddedCourseData = [...myAddedCourseData, e];
        });
        isAddDataLoading = false;
      } else {
        myAddedCourseData = tempCourseData;

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

  Future<void> getCourseDataByUserId({required String userId, required String searchType}) async {
    try {
      List<CourseModel> tempCourseData = [];
      if (searchType == "AddData") {
        tempCourseData = await _dbService.getAllCourses();
      } else {
        if (searchType == "First") {
          isFirstLoading = true;
          Future.delayed(Duration.zero).then((value) => notifyListeners());
        }
        tempCourseData = await _dbService.getCoursesByUserId(userId, isFirst: true);
      }

      if (searchType == "AddData") {
        tempCourseData.forEach((e) {
          myCourseData = [...myCourseData, e];
        });
        isAddDataLoading = false;
      } else {
        myCourseData = tempCourseData;
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

  void addData() {
    isAddDataLoading = true;
    notifyListeners();
  }

  void reLoadingPage() {
    isReLoading = true;
    notifyListeners();
  }
}
