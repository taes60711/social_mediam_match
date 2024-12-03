import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/Initial/Initial_page.dart';
import '../../enum/skill_type.dart';
import '../../models/course_model.dart';
import '../../models/skill_model.dart';

class CourseEditingModel {
  String title;
  final String content;
  final String beforeNeed;
  final String courseDetailContent;
  final String courseChoiceLevel;
  final String courseChoiceType;
  final List<RequestSkillListData> courseEditSkillList;
  final List<CourseChapterInfo> courseEditChapterList;
  final bool isPublic;

  CourseEditingModel({
    required this.title,
    required this.content,
    required this.beforeNeed,
    required this.courseDetailContent,
    required this.courseChoiceLevel,
    required this.courseChoiceType,
    required this.courseEditSkillList,
    required this.courseEditChapterList,
    required this.isPublic,
  });

  CourseEditingModel copyWithCourse() {
    return CourseEditingModel(
      title: title,
      content: content,
      beforeNeed: beforeNeed,
      courseDetailContent: courseDetailContent,
      courseChoiceLevel: courseChoiceLevel,
      courseChoiceType: courseChoiceType,
      courseEditSkillList: courseEditSkillList.map((e) => e.copy()).toList(),
      courseEditChapterList: courseEditChapterList.map((e) => e.copy()).toList(),
      isPublic: isPublic,
    );
  }

  CourseEditingModel.emptyData()
      : title = '',
        content = '',
        beforeNeed = '',
        courseDetailContent = '',
        courseChoiceLevel = '',
        courseChoiceType = '',
        courseEditSkillList = [],
        courseEditChapterList = [],
        isPublic = true;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'beforeNeed': beforeNeed,
      'courseDetailContent': courseDetailContent,
      'courseChoiceLevel': courseChoiceLevel,
      'courseChoiceType': courseChoiceType,
      'courseEditSkillList': courseEditSkillList.map((e) => e.toJson()).toList(),
      'courseEditChapterList': courseEditChapterList.map((e) => e.toJson()).toList(),
      'isPublic': isPublic,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

///CourseEditViewModel
class CourseEditViewModel {
  late BuildContext context;
  late WidgetRef ref;
  late Function render;

  void init(BuildContext context, WidgetRef ref, Function render) {
    this.context = context;
    this.ref = ref;
    this.render = render;
  }

  CourseEditingModel beforeEditData = CourseEditingModel.emptyData();
  CourseEditingModel editingData = CourseEditingModel.emptyData();

  TextEditingController titleController = TextEditingController();
  String titleErr = "";
  TextEditingController contentController = TextEditingController();
  String contentErr = "";
  TextEditingController beforeNeedController = TextEditingController();

  String learningSkillListErr = "";
  bool isPublic = true;

  String chapterErr = "";

  void initData({CourseModel? courseData}) {
    if (courseData != null) {
      List<RequestSkillListData> formatListData = [];

      for (var element in courseData.courseLearningSkills) {
        int index = ref.read(allSkillListData).indexWhere((e) => e.name == element);
        if (index != -1) {
          formatListData.add(ref.read(allSkillListData)[index]);
        }
      }

      editingData = CourseEditingModel(
        title: courseData.title,
        content: courseData.content,
        beforeNeed: courseData.beforeNeed,
        courseDetailContent: courseData.prStory,
        courseChoiceLevel: courseData.needLevel.toString(),
        courseChoiceType: courseData.type.toString(),
        courseEditSkillList: formatListData,
        courseEditChapterList: List.from(courseData.chapterList),
        isPublic: courseData.isPublic,
      );
      titleController.text = editingData.title;
      contentController.text = editingData.content;
      beforeNeedController.text = editingData.beforeNeed;

      ref.read(courseDetailContent.notifier).update((state) => courseData.prStory);
      ref.read(courseEditSkillList.notifier).update((state) => List.from(formatListData));
      ref.read(courseEditChapterList.notifier).update((state) => List.from(courseData.chapterList));
      ref.read(courseChoiceLevel.notifier).update((state) => courseData.needLevel.toString());

      ref.read(courseChoiceType.notifier).update((state) => courseData.type.toString());
    } else {
      editingData = CourseEditingModel(
        title: titleController.text,
        content: contentController.text,
        beforeNeed: beforeNeedController.text,
        courseDetailContent: ref.read(courseDetailContent),
        courseChoiceLevel: ref.read(courseChoiceLevel.notifier).state,
        courseChoiceType: ref.read(courseChoiceType),
        courseEditSkillList: ref.read(courseEditSkillList),
        courseEditChapterList: ref.read(courseEditChapterList),
        isPublic: isPublic,
      );
    }

    beforeEditData = editingData.copyWithCourse();

    render();
  }

  void isPublicStatusOnChange() {
    isPublic = !isPublic;
    render();
  }

  void updateEditData() {
    editingData = CourseEditingModel(
      title: titleController.text,
      content: contentController.text,
      beforeNeed: beforeNeedController.text,
      courseDetailContent: ref.read(courseDetailContent),
      courseChoiceLevel: ref.read(courseChoiceLevel.notifier).state,
      courseChoiceType: ref.read(courseChoiceType),
      courseEditSkillList: ref.read(courseEditSkillList),
      courseEditChapterList: ref.read(courseEditChapterList),
      isPublic: isPublic,
    );
  }

  bool sendBeforeCheck() {
    bool isOk = true;
    errReset();
    updateEditData();
    if (editingData.title.replaceAll(" ", "") == "") {
      isOk = false;
      titleErr = "標題不得為空";
    }
    if (editingData.content.replaceAll(" ", "") == "") {
      isOk = false;
      contentErr = "大綱不得為空";
    }

    if (editingData.courseEditSkillList.isEmpty) {
      isOk = false;
      learningSkillListErr = "請至少選擇一個以上的技能";
    }

    if (ref.read(courseEditChapterList).isEmpty) {
      isOk = false;
      chapterErr = "至少要填寫一個章節";
    }

    render();

    return isOk;
  }

  bool isEditedCheck() {
    bool isEdited = false;
    updateEditData();
    if (beforeEditData.toJsonString() != editingData.toJsonString()) {
      isEdited = true;
    }
    return isEdited;
  }

  void errReset() {
    titleErr = "";
    contentErr = "";
    learningSkillListErr = "";
    chapterErr = "";
  }

  void resetAllData() {
    errReset();
    ref.read(courseDetailContent.notifier).update((state) => "");
    ref.read(courseEditSkillList.notifier).update((state) => []);
    ref.read(courseEditChapterList.notifier).update((state) => []);
    ref.read(courseChoiceLevel.notifier).update((state) => "3");
    ref.read(courseChoiceType.notifier).update((state) => SkillType.frontend.type.toString());
  }
}

final courseChoiceLevel = StateProvider<String>((ref) {
  return "3";
});

final courseChoiceType = StateProvider<String>((ref) {
  return SkillType.frontend.type.toString();
});

final courseEditSkillList = StateProvider<List<RequestSkillListData>>((ref) {
  return [];
});

final courseEditChapterList = StateProvider<List<CourseChapterInfo>>((ref) => []);

final courseDetailContent = StateProvider<String>((ref) {
  return "";
});
