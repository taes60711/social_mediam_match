import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_skill_filter_page.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import '../../../../models/course_model.dart';
import '../../../../provider/course/corse_edit_view_model.dart';
import '../../../../provider/course/course_provider.dart';
import '../../../../services/course_service.dart';
import '../../../utilities/common_scaffold.dart';
import '../../../utilities/appBar/basic_top_bar.dart';
import '../../../utilities/dialog/cant_touch_loading_dialog.dart';
import '../../../utilities/dialog/confirm_dialog.dart';
import '../../../utilities/main_button.dart';
import '../../../utilities/custom_expansion_title.dart';
import '../../../utilities/inputField/base_input.dart';
import '../../../utilities/inputField/mutl_input.dart';
import '../../../utilities/rich_text_view.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';
import 'course_edit_page/course_level_choice_label.dart';
import 'course_edit_page/course_rich_text_create.dart';
import 'course_edit_page/course_rich_text_edit.dart';
import 'course_edit_page/course_type_choiced_label.dart';

class CourseCreatePage extends BaseFadeScalePage {
  late CourseEditViewModel viewModel = CourseEditViewModel();

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel.init(context, ref, () => render());
    viewModel.initData();
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
                  if (viewModel.isEditedCheck()) {
                    ConfirmDilaog(
                        title: '提示',
                        content: '正在編輯中, 確定要離開嗎？',
                        conirmFunc: () {
                          viewModel.resetAllData();
                          closePage();
                        }).show(context);
                  } else {
                    viewModel.resetAllData();
                    closePage();
                  }
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
                  if (!viewModel.sendBeforeCheck()) {
                    return;
                  }
                  CanTouchScreenLoadingDialog().show();
                  ProfileData userData = ref.read(loginUserData);

                  CourseEditingModel courseEditingData = viewModel.editingData;

                  List<String> learningSkillList = courseEditingData.courseEditSkillList.map((e) => e.name).toList();

                  int index = await CourseService().createOrUpdateCourse(
                    createdBy: userData.uid,
                    title: courseEditingData.title,
                    needLevel: courseEditingData.courseChoiceLevel,
                    content: courseEditingData.content,
                    beforeNeed: courseEditingData.beforeNeed,
                    prStory: courseEditingData.courseDetailContent,
                    chapterList: courseEditingData.courseEditChapterList,
                    courseLearningSkills: learningSkillList,
                    type: courseEditingData.courseChoiceType,
                    isPublic: courseEditingData.isPublic,
                  );

                  CourseModel createdCourse = CourseModel(
                    id: index,
                    createdBy: userData.uid,
                    title: courseEditingData.title,
                    needLevel: int.parse(courseEditingData.courseChoiceLevel),
                    content: courseEditingData.content,
                    beforeNeed: courseEditingData.beforeNeed,
                    prStory: courseEditingData.courseDetailContent,
                    chapterList: courseEditingData.courseEditChapterList,
                    courseLearningSkills: learningSkillList,
                    type: int.parse(courseEditingData.courseChoiceType),
                    postTime: DateTime.now().toUtc().toString(),
                    isPublic: courseEditingData.isPublic,
                    signUpStatus: "none",
                    courseCreateduserInfo: userData,
                  );

                  CanTouchScreenLoadingDialog().close();
                  ref.read(courseMainPageListPorver.notifier).addDataTofirst(createdCourse);
                  await Future.delayed(const Duration(milliseconds: 100));
                  ref.read(courseMainPageListPorver).scrollController.jumpTo(0);
                  viewModel.resetAllData();
                  closePage();
                },
                title: "投稿",
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    inputField(
                      hintText: "標題",
                      editingController: viewModel.titleController,
                      fontSzie: ScreenSize.fontSize24,
                      errMsg: viewModel.titleErr,
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    multiInputField(
                      hintText: "大綱",
                      editingController: viewModel.contentController,
                      errMsg: viewModel.contentErr,
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),
                    multiInputField(
                      hintText: "前置需求",
                      editingController: viewModel.beforeNeedController,
                    ),

                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    ///レベル設定
                    const CourseLevelChoicedLabel(),
                    SizedBox(height: ScreenSize.fitPxHeight(15)),

                    /// タグ設定
                    const CourseTypeChoicedLabel(),
                    SizedBox(height: ScreenSize.fitPxHeight(15)),
                    skillChoiceBuild(
                      errMsg: viewModel.learningSkillListErr,
                    ),
                    SizedBox(height: ScreenSize.fitPxHeight(15)),

                    ///詳細内容
                    courseDetailEdit(),
                    SizedBox(height: ScreenSize.fitPxHeight(10)),

                    /// チャプター追加ボタン　＆　公開チェックボックス
                    couseChapterCreateBuild(),

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
                              Icon(
                                FontAwesomeIcons.book,
                                color: Colors.white,
                                size: ScreenSize.fontSize14,
                              ),
                              SizedBox(width: ScreenSize.fitPxWidth(5)),
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
                                    courseChapterInfo: value,
                                    courseChaterIndex: index,
                                  ).show(context);
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: ScreenSize.fontSize20,
                                  color: AppColors.orangeColor,
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
                                  color: AppColors.orangeColor,
                                ),
                              ),
                              Visibility(
                                visible: index != ref.watch(courseEditChapterList).length - 1,
                                child: Row(
                                  children: [
                                    SizedBox(width: ScreenSize.fitPxWidth(10)),
                                    MainBtn(
                                      onPress: () {
                                        List<CourseChapterInfo> chapterList = ref.read(courseEditChapterList.notifier).state;

                                        if (index < chapterList.length - 1) {
                                          var temp = chapterList[index];
                                          chapterList[index] = chapterList[index + 1];
                                          chapterList[index + 1] = temp;

                                          ref.read(courseEditChapterList.notifier).update((state) => chapterList);

                                          render();
                                        }
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.arrowTurnDown,
                                        size: ScreenSize.fontSize16,
                                        color: AppColors.orangeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          children: [
                            SizedBox(height: ScreenSize.fitPxWidth(5)),
                            RichTextView(content: value.content[0]),
                            SizedBox(height: ScreenSize.fitPxWidth(10)),
                          ],
                        );
                      }).toList(),
                    ),
                    Visibility(
                      visible: viewModel.chapterErr != "",
                      child: Text(
                        viewModel.chapterErr,
                        style: TextStyle(
                          color: AppColors.redColor,
                          fontSize: ScreenSize.fontSize14,
                        ),
                      ),
                    )
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
  Widget skillChoiceBuild({String? errMsg}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainBtn(
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
                            ScreenSize.fitPxWidth(100),
                          ),
                        ),
                        child: Text(
                          "尚無",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: ScreenSize.fontSize14,
                          ),
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
                                    ScreenSize.fitPxWidth(100),
                                  ),
                                ),
                                child: Text(
                                  e.name,
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: ScreenSize.fontSize14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: errMsg != null && errMsg != "",
          child: Text(
            errMsg ?? "",
            style: TextStyle(
              color: AppColors.redColor,
              fontSize: ScreenSize.fontSize14,
            ),
          ),
        )
      ],
    );
  }

  Widget inputField(
      {required String hintText, required TextEditingController editingController, double? fontSzie, String? errMsg}) {
    double fs = fontSzie ?? ScreenSize.fontSize18;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseInputField(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: fs),
          inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: fs),
          controller: editingController,
        ),
        Visibility(
          visible: errMsg != null && errMsg != "",
          child: Text(
            errMsg ?? "",
            style: TextStyle(
              color: AppColors.redColor,
              fontSize: ScreenSize.fontSize14,
            ),
          ),
        )
      ],
    );
  }

  Widget multiInputField({required String hintText, required TextEditingController editingController, String? errMsg}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MultInput(
          controller: editingController,
          hintText: hintText,
          minLines: 3,
          maxLines: 3,
          editPageMaxLines: 10,
          editPageMinLines: 10,
        ),
        Visibility(
          visible: errMsg != null && errMsg != "",
          child: Text(
            errMsg ?? "",
            style: TextStyle(
              color: AppColors.redColor,
              fontSize: ScreenSize.fontSize14,
            ),
          ),
        )
      ],
    );
  }

  /// 詳細内容
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
                if (ref.read(courseDetailContent) != "") {
                  CourseRichTextEdit(courseEditPageRender: render, content: ref.read(courseDetailContent)).show(context);
                } else {
                  CourseRichTextCreate(courseEditPageRender: render).show(context);
                }
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: ScreenSize.fontSize20,
                    color: AppColors.orangeColor,
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

  /// チャプター追加ボタン　＆　公開チェックボックス
  Widget couseChapterCreateBuild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// チャプター追加ボタン
        GestureDetector(
          onTap: () {
            CourseRichTextCreate(courseEditPageRender: render, ediType: CreateEdiType.chapter).show(context);
          },
          child: Row(
            children: [
              Text(
                "章節",
                style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
              ),
              Container(
                width: 30,
                height: 30,
                color: Colors.transparent,
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: AppColors.greyColor130,
                  size: ScreenSize.fontSize14,
                ),
              ),
            ],
          ),
        ),

        ///公開チェックボックス
        GestureDetector(
          onTap: () {
            viewModel.isPublicStatusOnChange();
          },
          child: Row(
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                activeColor: AppColors.orangeColor,
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                    width: 0.8,
                    color: AppColors.orangeColor,
                  ),
                ),
                value: viewModel.isPublic,
                onChanged: (value) {
                  viewModel.isPublicStatusOnChange();
                },
              ),
              Text(
                "公開",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: ScreenSize.fontSize14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
