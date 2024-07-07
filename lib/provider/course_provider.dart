import 'package:flutter/material.dart';
import 'package:social_mediam_match/models/course_model.dart';
import '../components/utilities/endDrawers/course_detail_end_drawer.dart';
import '../components/utilities/endDrawers/course_edit_skill_choice_end_drawer.dart';
import '../components/utilities/endDrawers/course_filter_end_drawer.dart';
import '../components/utilities/endDrawers/course_manager_end_drawer.dart';
import '../models/user_model.dart';

class CourseProvider extends ChangeNotifier {
  // MARK: EditView
  bool isPublic = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController beforeNeedController = TextEditingController();
  String contentText = "";
  String beforeNeedText = "";
  String prStory = "";
  String needLevel = '0';
  String type = '0';

  List<String> skillList = [];
  List<String> choicedSkillList = [];
  List<CourseChapterInfo> chapters = [];
  void editPageInit({required List<String> requestSkillList, CourseModel? courseData}) {
    if (courseData != null) {
      //文章編集
      titleController.text = courseData.title;
      contentController.text = courseData.content;
      beforeNeedController.text = courseData.beforeNeed;
      contentText = courseData.content;
      beforeNeedText = courseData.beforeNeed;
      isPublic = courseData.isPublic;
      needLevel = "${courseData.needLevel}";
      choicedSkillList = courseData.courseLearningSkills;
      chapters = courseData.chapterList;
      prStory = courseData.prStory;
    }

    skillList = [...skillList, ...requestSkillList];
    notifyListeners();
  }

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

  void prStoryOnChange(String changedPrStory) {
    prStory = changedPrStory;
    notifyListeners();
  }

  void isPublicOnChange() {
    isPublic = !isPublic;
    notifyListeners();
  }

  void beforeNeedOnChange(String content) {
    beforeNeedText = content;
    notifyListeners();
  }

  void contentOnChange(String content) {
    contentText = content;
    notifyListeners();
  }

  void needLevelChange(String value, String wantChangeValue) {
    if (wantChangeValue == "needLevel") {
      needLevel = value;
    } else if (wantChangeValue == "type") {
      type = value;
    }
    notifyListeners();
  }

  void onChangeChoiceSkill(String skillName) {
    if (!choicedSkillList.any((element) => element == skillName)) {
      choicedSkillList.add(skillName);
    } else {
      choicedSkillList.remove(skillName);
    }
    notifyListeners();
  }

  CourseEditSkillChoiceEndDrawerType editSkillChoiceEndDrawerOpenInfo = CourseEditSkillChoiceEndDrawerType.close;
  void editSkillChoiceEndDrawerStatus(CourseEditSkillChoiceEndDrawerType status) {
    editSkillChoiceEndDrawerOpenInfo = status;
    notifyListeners();
  }

  // MARK: View
  bool bIsAddedCourse = true;
  void courseSignedUp({required bool isAdded}) async {
    bIsAddedCourse = isAdded;
    notifyListeners();
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
