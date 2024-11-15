import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_skill_filter_page.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';

import '../../../../models/course_model.dart';
import '../../../../models/skill_model.dart';
import '../../../../provider/course_provider.dart';
import '../../../../services/course_service.dart';
import '../../../utilities/background_widget.dart';
import '../../../utilities/basic_top_bar.dart';
import '../../../utilities/bottomSheets/base_bottom_sheet.dart';
import '../../../utilities/custom_button.dart';
import '../../../utilities/custom_expansion_title.dart';
import '../../../utilities/inputField/base_input.dart';
import '../../../utilities/rich_text_view.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';
import 'course_rich_text_edit.dart';

class CourseEditPage extends BaseFadeScalePage {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController beforeNeedController = TextEditingController();
  bool isPublic = true;

  List<CourseChapterInfo> chapters = [];
  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      type: PageType.main,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  ProfileData userData = ref.read(loginUserData);
                  List<String> learningSkillList = ref.read(courseEditSkillList).map((e) => e.name).toList();

                  int index = await CourseService().createOrUpdateCourse(
                    createdBy: userData.uid,
                    title: titleController.text,
                    needLevel: ref.read(courseChoiceLevel.notifier).state,
                    content: contentController.text,
                    beforeNeed: beforeNeedController.text,
                    prStory: ref.read(courseDetailContent),
                    chapterList: ref.read(courseEditChapterList),
                    courseLearningSkills: learningSkillList,
                    type: "1",
                    isPublic: isPublic,
                  );
                  CourseModel createdCourse = CourseModel(
                    id: index,
                    createdBy: userData.uid,
                    title: titleController.text,
                    needLevel: int.parse(ref.read(courseChoiceLevel.notifier).state),
                    content: contentController.text,
                    beforeNeed: beforeNeedController.text,
                    prStory: ref.read(courseDetailContent),
                    chapterList: ref.read(courseEditChapterList),
                    courseLearningSkills: learningSkillList,
                    type: 1,
                    isPublic: isPublic,
                    signUpStatus: "none",
                    courseCreateduserInfo: userData,
                  );
                  ref.read(courseMainPageListPorver.notifier).addDataTofirst(createdCourse);
                  await Future.delayed(const Duration(milliseconds: 100));
                  ref.read(courseMainPageListPorver).scrollController.jumpTo(0);
                  pageClosePage();
                },
                title: "投稿",
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            inputField(hintText: "標題", editingController: titleController, fontSzie: ScreenSize.fontSize24),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            inputField(hintText: "大綱", editingController: contentController),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            inputField(hintText: "前置需求", editingController: beforeNeedController),
            SizedBox(height: ScreenSize.fitPxHeight(5)),

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

class CourseLevelChoicedLabel extends ConsumerStatefulWidget {
  const CourseLevelChoicedLabel({super.key});

  @override
  ConsumerState<CourseLevelChoicedLabel> createState() => _CourseLevelChoicedLabelState();
}

class _CourseLevelChoicedLabelState extends ConsumerState<CourseLevelChoicedLabel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "難度",
          style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
        ),
        SizedBox(width: ScreenSize.fitPxWidth(10)),
        MainBtn(
            onPress: () {
              CourseLevelChoiceBottomSheet().show(context);
            },
            child: boardContaienr(
              Row(
                children: [
                  Text(
                    ref.watch(courseChoiceLevel),
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
                  ),
                  SizedBox(width: ScreenSize.fitPxWidth(5)),
                  Icon(
                    FontAwesomeIcons.caretDown,
                    size: ScreenSize.fontSize16,
                    color: AppColors.whiteColor,
                  )
                ],
              ),
            )),
      ],
    );
  }

  Widget boardContaienr(Widget child) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.fitPxHeight(5),
          vertical: ScreenSize.fitPxHeight(1),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.greyColor98,
        ),
        child: child);
  }
}

class CourseLevelChoiceBottomSheet extends BaseBottomSheet {
  FixedExtentScrollController scrollController = FixedExtentScrollController();
  List<String> item = [];
  @override
  double buildHeight() {
    return 0.3;
  }

  @override
  Future<void> initState(WidgetRef ref) async {
    item = ["1", "2", "3", "4", "5"];

    int choicedItemsIndex = item.indexWhere((element) => element == ref.read(courseChoiceLevel.notifier).state);

    if (choicedItemsIndex != -1) {
      scrollController.jumpToItem(choicedItemsIndex);
    }

    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return CupertinoPicker(
      scrollController: scrollController,
      itemExtent: 50,
      onSelectedItemChanged: (int index) {
        ref.read(courseChoiceLevel.notifier).update((state) => item[index]);
        render();
      },
      children: item
          .map(
            (e) => Center(
              child: Text(
                e,
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ),
          )
          .toList(),
    );
  }
}

final courseChoiceLevel = StateProvider<String>((ref) {
  return "3";
});

final courseEditSkillList = StateProvider<List<RequestSkillListData>>((ref) {
  return [];
});

final courseEditChapterList = StateProvider<List<CourseChapterInfo>>((ref) => []);

final courseDetailContent = StateProvider<String>((ref) {
  return "";
});
