import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/Initial/Initial_page.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_skill_filter_page.dart';
import 'package:social_mediam_match/models/skill_model.dart';
import '../../../../models/course_model.dart';
import '../../../../provider/course_provider.dart';
import '../../../../services/course_service.dart';
import '../../../utilities/apiListView/api_list_controller.dart';
import '../../../utilities/background_widget.dart';
import '../../../utilities/basic_top_bar.dart';
import '../../../utilities/main_button.dart';
import '../../../utilities/custom_expansion_title.dart';
import '../../../utilities/inputField/base_input.dart';
import '../../../utilities/inputField/mutl_input.dart';
import '../../../utilities/rich_text_view.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';
import 'course_edit_page/course_level_choice_label.dart';
import 'course_edit_page/course_rich_text_edit.dart';

class CourseEditPage extends BaseFadeScalePage {
  StateNotifierProvider<APIListControllerNotifier<CourseModel>, APIListController<CourseModel>> courseListController;

  int dataIndex;
  CourseEditPage(this.courseListController, {required this.dataIndex});

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController beforeNeedController = TextEditingController();
  bool isPublic = true;

  @override
  Future<void> initState(WidgetRef ref) async {
    CourseModel courseData = ref.read(choicedCourseProvider);
    titleController.text = courseData.title;
    contentController.text = courseData.content;
    beforeNeedController.text = courseData.beforeNeed;

    ref.read(courseDetailContent.notifier).update((state) => courseData.prStory);

    List<RequestSkillListData> formatListData = [];

    for (var element in courseData.courseLearningSkills) {
      int index = ref.read(allSkillListData).indexWhere((e) => e.name == element);
      if (index != -1) {
        formatListData.add(ref.read(allSkillListData)[index]);
      }
    }

    ref.read(courseEditSkillList.notifier).update((state) => List.from(formatListData));
    ref.read(courseEditChapterList.notifier).update((state) => List.from(courseData.chapterList));
    ref.read(courseChoiceLevel.notifier).update((state) => courseData.needLevel.toString());

    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      type: PageType.main,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
        child: Column(
          children: [
            BaseTopBar(
              leftWidget: GestureDetector(
                onTap: () {
                  pageClosePage();
                },
                child: Container(
                  width: ScreenSize.fitPxWidth(40),
                  height: ScreenSize.fitPxWidth(40),
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: ScreenSize.fontSize18,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
              rightWidget: MainBtn(
                onPress: () async {
                  List<String> learningSkillList = ref.read(courseEditSkillList).map((e) => e.name).toList();

                  CourseModel updateCourse = CourseModel(
                    id: ref.read(choicedCourseProvider).id,
                    createdBy: ref.read(choicedCourseProvider).courseCreateduserInfo.uid,
                    title: titleController.text,
                    needLevel: int.parse(ref.read(courseChoiceLevel.notifier).state),
                    content: contentController.text,
                    beforeNeed: beforeNeedController.text,
                    prStory: ref.read(courseDetailContent),
                    chapterList: ref.read(courseEditChapterList),
                    courseLearningSkills: learningSkillList,
                    type: ref.read(choicedCourseProvider).type,
                    isPublic: isPublic,
                    signUpStatus: ref.read(choicedCourseProvider).signUpStatus,
                    courseCreateduserInfo: ref.read(choicedCourseProvider).courseCreateduserInfo,
                    postTime: ref.read(choicedCourseProvider).postTime,
                  );

                  int result = await CourseService().createOrUpdateCourse(
                    createdBy: updateCourse.createdBy,
                    title: updateCourse.title,
                    needLevel: updateCourse.needLevel.toString(),
                    content: updateCourse.content,
                    beforeNeed: updateCourse.beforeNeed,
                    prStory: updateCourse.prStory,
                    chapterList: updateCourse.chapterList,
                    courseLearningSkills: updateCourse.courseLearningSkills,
                    type: updateCourse.type.toString(),
                    isPublic: isPublic,
                    courseId: updateCourse.id,
                  );

                  /// -100 = success ; -101 = fail
                  if (result == -100) {
                    ref.read(courseListController.notifier).editData(dataIndex, updateCourse);
                    pageClosePage();
                  }
                },
                title: "修改",
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    inputField(hintText: "標題", editingController: titleController, fontSzie: ScreenSize.fontSize24),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    multiInputField(hintText: "大綱", editingController: contentController),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),
                    multiInputField(hintText: "前置需求", editingController: beforeNeedController),

                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    ///レベル設定
                    const CourseLevelChoicedLabel(),
                    SizedBox(height: ScreenSize.fitPxHeight(15)),
                    skillChoiceBuild(),
                    SizedBox(height: ScreenSize.fitPxHeight(15)),

                    ///詳細内容
                    courseDetailEdit(),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    /// チャプター追加ボタン　＆　公開チェックボックス
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// チャプター追加ボタン
                        GestureDetector(
                          onTap: () {
                            CourseRichTextEdit(courseEditPageRender: render, ediType: EdiType.chapter).show(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                "章節",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                color: Colors.transparent,
                                child: Icon(
                                  FontAwesomeIcons.plus,
                                  color: AppColors.greyColor130,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///公開チェックボックス
                        GestureDetector(
                          onTap: () {
                            isPublic = !isPublic;
                            render();
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                activeColor: normalBgColor,
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => BorderSide(width: 0.8, color: normalBgColor),
                                ),
                                value: isPublic,
                                onChanged: (value) {
                                  isPublic = !isPublic;
                                  render();
                                },
                              ),
                              Text(
                                "公開",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    ///チャプター内容
                    Column(
                      children: ref.watch(courseEditChapterList).asMap().entries.map((e) {
                        int index = e.key;
                        CourseChapterInfo value = e.value;

                        return CustomExpansionTile(
                          initiallyExpanded: true,
                          isNeedLoadingWidget: false,
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  value.chapterName == "" ? "chapter ${value.chapter}" : value.chapterName,
                                  style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
                                ),
                              ),
                              MainBtn(
                                onPress: () {
                                  CourseRichTextEdit(
                                    courseEditPageRender: render,
                                    ediType: EdiType.chapter,
                                    tite: value.chapterName,
                                    content: value.content[0],
                                  ).show(context);
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: ScreenSize.fontSize20,
                                  color: normalBgColor,
                                ),
                              ),
                              SizedBox(width: ScreenSize.fitPxWidth(10)),
                              MainBtn(
                                onPress: () {
                                  List<CourseChapterInfo> chapterList = ref.read(courseEditChapterList.notifier).state;

                                  chapterList.removeAt(index);
                                  ref.read(courseEditChapterList.notifier).update((state) => chapterList);
                                  render();
                                },
                                child: Icon(
                                  Icons.close,
                                  size: ScreenSize.fontSize20,
                                  color: normalBgColor,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            RichTextView(content: value.content[0]),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// スキル設定
  Widget skillChoiceBuild() {
    return MainBtn(
      onPress: () {
        BaseSkillFilterPage(
          viewRender: render,
          filteredSkillList: courseEditSkillList,
          btnStr: "確認",
          searchFunc: (list) {
            ref.read(courseEditSkillList.notifier).update((state) => list);
          },
        ).show(context);
      },
      child: Container(
        width: ScreenSize.width,
        color: Colors.transparent,
        child: Row(
          children: [
            Text(
              "學習的技能",
              style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
            ),
            ref.read(courseEditSkillList).isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.fitPxWidth(5),
                      vertical: ScreenSize.fitPxWidth(3),
                    ),
                    margin: EdgeInsets.only(left: ScreenSize.fitPxWidth(8)),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor57,
                      borderRadius: BorderRadius.circular(
                        ScreenSize.fitPxWidth(8),
                      ),
                    ),
                    child: Text(
                      "尚無",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ref.read(courseEditSkillList).map((e) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenSize.fitPxWidth(5),
                              vertical: ScreenSize.fitPxWidth(3),
                            ),
                            margin: EdgeInsets.only(left: ScreenSize.fitPxWidth(8)),
                            decoration: BoxDecoration(
                              color: AppColors.greyColor57,
                              borderRadius: BorderRadius.circular(
                                ScreenSize.fitPxWidth(8),
                              ),
                            ),
                            child: Text(
                              e.name,
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget inputField({required String hintText, required TextEditingController editingController, double? fontSzie}) {
    double fs = fontSzie ?? ScreenSize.fontSize18;
    return BaseInputField(
      hintText: hintText,
      hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: fs),
      inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
      controller: editingController,
    );
  }

  Widget multiInputField({required String hintText, required TextEditingController editingController}) {
    return MultInput(
      controller: editingController,
      hintText: hintText,
      minLines: 3,
      maxLines: 3,
      editPageMaxLines: 10,
      editPageMinLines: 10,
    );
  }

  Widget courseDetailEdit() {
    return Builder(builder: (context) {
      return CustomExpansionTile(
        initiallyExpanded: true,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "詳細內容",
                style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
              ),
            ),
            MainBtn(
              onPress: () {
                CourseRichTextEdit(courseEditPageRender: render).show(context);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: ScreenSize.fontSize20,
                    color: normalBgColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "編輯",
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.8),
                      fontSize: ScreenSize.fontSize18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          RichTextView(content: ref.watch(courseDetailContent.notifier).state),
        ],
      );
    });
  }

  void pageClosePage() {
    resetAllData();
    closePage();
  }

  void resetAllData() {
    ref.read(courseDetailContent.notifier).update((state) => "");
    ref.read(courseEditSkillList.notifier).update((state) => []);
    ref.read(courseEditChapterList.notifier).update((state) => []);
    ref.read(courseChoiceLevel.notifier).update((state) => "3");
  }
}
