import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/course_model.dart';
import '../components/utilities/endDrawers/course_detail_end_drawer.dart';
import '../components/utilities/endDrawers/course_filter_end_drawer.dart';
import '../components/utilities/endDrawers/course_manager_end_drawer.dart';
import '../global.dart';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import '../services/db_service.dart';

class CourseState extends ChangeNotifier {
  final DBService _dbService = DBService();

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

  CourseModel choicedCourse = CourseModel(courseCreateduserInfo: LoginUser());
  CourseDetailEndDrawerType endDrawerOpenInfo = CourseDetailEndDrawerType.close;
  void changeEndDrawerStatus(CourseDetailEndDrawerType status, CourseModel opendCourse) {
    endDrawerOpenInfo = status;
    choicedCourse = opendCourse;
    notifyListeners();
  }

  CourseFilterEndDrawerType filterEndDrawerOpenInfo = CourseFilterEndDrawerType.close;
  void changeFilterEndDrawerStatus(CourseFilterEndDrawerType status) {
    filterEndDrawerOpenInfo = status;
    notifyListeners();
  }

  CourseManagerEndDrawerType courseManagerEndDrawerOpenInfo = CourseManagerEndDrawerType.close;
  int choicedCourseId = -1;
  void courseManagerEndDrawerStatus(CourseManagerEndDrawerType status, int changedCourseId) {
    courseManagerEndDrawerOpenInfo = status;
    choicedCourseId = changedCourseId;
    notifyListeners();
  }
}
