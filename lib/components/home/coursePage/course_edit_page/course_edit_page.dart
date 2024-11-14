// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/account/skill_bar.dart';
// import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
// import 'package:social_mediam_match/components/utilities/custom_button.dart';
// import 'package:social_mediam_match/components/utilities/endDrawers/skill_setting_end_drawer.dart';
// import 'package:social_mediam_match/components/utilities/rich_text_view.dart';
// import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
// import 'package:social_mediam_match/components/utilities/style/style_config.dart';
// import 'package:social_mediam_match/components/utilities/label_input.dart';
// import 'package:social_mediam_match/provider/corse_view_model.dart';
// import '../../../../models/course_model.dart';
// import '../../../../provider/course_provider.dart';
// import '../../../utilities/basic_top_bar.dart';
// import '../../../utilities/custom_expansion_title.dart';
// import '../../../utilities/endDrawers/course_edit_skill_choice_end_drawer.dart';

// class CourseEditPage extends StatelessWidget {
//   const CourseEditPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     CourseModel? courseData = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['courseData'] as CourseModel?;
//     BuildContext courseContext = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['context'] as BuildContext;
//     return StatefulWrapper(
//       onInit: () async {
//         await CourseViewModel(courseContext: context).courseEditInit(courseData: courseData);
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             SafeArea(
//               child: Column(
//                 children: [
//                   BaseTopBar(
//                     title: "編輯課程",
//                     rightWidget: TextBtn(
//                       title: "保存",
//                       btnWidth: 80,
//                       verticalMargin: 6,
//                       btnColor: normalBgColor,
//                       onPress: () async {
//                         int? id;
//                         if (courseData != null) {
//                           id = courseData.id;
//                         }
//                         CourseViewModel(courseContext: context)
//                             .courseCreateOrUpdate(courseId: id, viewListContext: courseContext);
//                       },
//                     ),
//                   ),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             courseTitleEdit(),
//                             courseContentEdit(),
//                             courseBeforeNeedEdit(),
//                             courseLeveEdit(),
//                             courseLearningSkillEdit(),
//                             const SizedBox(height: 15),
//                             courseDetailEdit(),
//                             const SizedBox(height: 15),
//                             courseChapterEdit(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             coursEditSkillEndDrawer(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget courseTitleEdit() {
//   return Builder(builder: (context) {
//     TextEditingController titleController = context.select((CourseProvider value) => value.titleController);
//     return LabelInput(
//       title: "標題",
//       textController: titleController,
//       padding: EdgeInsets.zero,
//     );
//   });
// }

// Widget courseContentEdit() {
//   return Builder(builder: (context) {
//     TextEditingController contentController = context.select((CourseProvider value) => value.contentController);
//     String contentText = context.select((CourseProvider value) => value.contentText);
//     return MultiLabelInput(
//       title: "課程大綱",
//       textController: contentController,
//       displayText: contentText,
//       padding: EdgeInsets.zero,
//       multiOnChange: (String value) => context.read<CourseProvider>().contentOnChange(value),
//     );
//   });
// }

// Widget courseBeforeNeedEdit() {
//   return Builder(builder: (context) {
//     TextEditingController beforeNeedController = context.select((CourseProvider value) => value.beforeNeedController);
//     String beforeNeedText = context.select((CourseProvider value) => value.beforeNeedText);
//     return MultiLabelInput(
//       title: "課程前需要",
//       textController: beforeNeedController,
//       displayText: beforeNeedText,
//       padding: EdgeInsets.zero,
//       multiOnChange: (String value) => context.read<CourseProvider>().beforeNeedOnChange(value),
//     );
//   });
// }

// Widget courseLeveEdit() {
//   return Builder(builder: (context) {
//     var items = ['0', '1', '2', '3', '4', '5'];
//     String needLevel = context.select((CourseProvider value) => value.needLevel);
//     return Row(
//       children: [
//         const Text("課程難度"),
//         const SizedBox(width: 10),
//         DropdownButton(
//           value: needLevel,
//           icon: const Icon(Icons.keyboard_arrow_down),
//           items: items.map((String items) {
//             return DropdownMenuItem(
//               value: items,
//               child: Text(items),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             context.read<CourseProvider>().needLevelChange(newValue ?? "1", "needLevel");
//           },
//         ),
//       ],
//     );
//   });
// }

// Widget courseLearningSkillEdit() {
//   return Builder(builder: (context) {
//     List<String> choicedSkillList = context.watch<CourseProvider>().choicedSkillList;
//     return GestureDetector(
//       onTap: () {
//         openCoursEditSkillEndDrawer(context: context);
//       },
//       child: Container(
//         width: ScreenSize.width,
//         color: Colors.transparent,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("學習的技能"),
//             const SizedBox(height: 5),
//             choicedSkillList.isEmpty
//                 ? Container(
//                     margin: const EdgeInsets.only(right: 5, bottom: 5),
//                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: normalBgColor,
//                     ),
//                     child: Text(
//                       tr("noskillData"),
//                       style: TextStyle(color: normalTextColor, fontSize: 14),
//                     ),
//                   )
//                 : skillBar(SkillEndDrawerType.close, courseSkillData: choicedSkillList),
//           ],
//         ),
//       ),
//     );
//   });
// }

// Widget courseDetailEdit() {
//   return Builder(builder: (context) {
//     String prStory = context.select((CourseProvider value) => value.prStory);
//     return CustomExpansionTile(
//       initiallyExpanded: true,
//       title: Row(
//         children: [
//           const Expanded(
//             child: Text("詳細介紹"),
//           ),
//           GestureDetector(
//             onTap: () {
//               CourseViewModel(courseContext: context).openRichEditPage(prStory: prStory);
//             },
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.edit,
//                   size: 18,
//                   color: normalBgColor,
//                 ),
//                 const SizedBox(width: 5),
//                 Text(
//                   "編輯",
//                   style: TextStyle(
//                     color: normalBgColor2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       children: <Widget>[
//         RichTextView(content: prStory),
//       ],
//     );
//   });
// }

// Widget courseChapterEdit() {
//   return Builder(builder: (context) {
//     List<CourseChapterInfo> chapters = context.watch<CourseProvider>().chapters;

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             /// チャプター追加ボタン
//             GestureDetector(
//               onTap: () {
//                 context.read<CourseProvider>().addChapter();
//               },
//               child: Row(
//                 children: [
//                   const Text("章節"),
//                   Container(
//                     width: 30,
//                     height: 30,
//                     color: Colors.transparent,
//                     child: Icon(
//                       FontAwesomeIcons.plus,
//                       color: normalBgColor2,
//                       size: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             ///公開チェックボックス
//             Builder(builder: (context) {
//               bool isPublic = context.select((CourseProvider value) => value.isPublic);
//               return GestureDetector(
//                 onTap: () {
//                   context.read<CourseProvider>().isPublicOnChange();
//                 },
//                 child: Row(
//                   children: [
//                     Checkbox(
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                       activeColor: normalBgColor,
//                       side: MaterialStateBorderSide.resolveWith(
//                         (states) => BorderSide(width: 0.8, color: normalBgColor),
//                       ),
//                       value: isPublic,
//                       onChanged: (value) {
//                         context.read<CourseProvider>().isPublicOnChange();
//                       },
//                     ),
//                     const Text("公開"),
//                   ],
//                 ),
//               );
//             }),
//           ],
//         ),
//         Column(
//           children: chapters.asMap().entries.map((e) {
//             int index = e.key;
//             CourseChapterInfo chapterInfo = e.value;

//             return CustomExpansionTile(
//               isNeedLoadingWidget: false,
//               initiallyExpanded: true,
//               collapsedTrailingWidget: const Icon(Icons.keyboard_arrow_up),
//               expandedTrailingWidget: const Icon(Icons.keyboard_arrow_down),
//               onTapPos: ExpansionTilteOnTapPos.traling,
//               title: Row(
//                 children: [
//                   Expanded(
//                     child: TextInput(
//                       textController: chapterInfo.chapterNameEditController!,
//                       onChanged: (str) {
//                         context.read<CourseProvider>().onChangeChapterTitleName(index, str);
//                       },
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       CourseViewModel(courseContext: context).openRichEditPage(chapterIndex: index);
//                     },
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: normalBgColor2,
//                       ),
//                       child: const Icon(
//                         FontAwesomeIcons.plus,
//                         color: Colors.white,
//                         size: 12,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),

//                   ///チャプター”タイトル”削除
//                   GestureDetector(
//                     onTap: () {
//                       context.read<CourseProvider>().deleteChapter(index);
//                     },
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: normalBgColor2,
//                       ),
//                       child: const Icon(
//                         FontAwesomeIcons.minus,
//                         color: Colors.white,
//                         size: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               children: chapters[index].content.asMap().entries.map((e) {
//                 int contentIndex = e.key;
//                 String content = e.value;

//                 int startIndex = '{"text":"'.length;
//                 int endIndex = content.indexOf('","');
//                 int startUrlIndex = content.indexOf('"url":"') + '"url":"'.length;
//                 int endUrlIndex = content.indexOf('"}');
//                 String chapterText = content.substring(startIndex, endIndex);
//                 String chapterUrl = content.substring(startUrlIndex, endUrlIndex);

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 5),
//                         child: Icon(
//                           Icons.ondemand_video,
//                           color: normalBgColor2,
//                         ),
//                       ),

//                       Expanded(
//                         ///チャプター開ける
//                         child: GestureDetector(
//                           onTap: () {
//                             CourseViewModel(courseContext: context).openCourseChapterContentPage(
//                               chapterText: chapterText,
//                               chapterUrl: chapterUrl,
//                             );
//                           },
//                           child: Text(
//                             chapterText,
//                             style: TextStyle(color: googleColor, decoration: TextDecoration.underline),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),

//                       ///チャプター削除
//                       GestureDetector(
//                         onTap: () {
//                           context.read<CourseProvider>().deleteChapterContent(index, contentIndex);
//                         },
//                         child: Container(
//                           width: 30,
//                           height: 30,
//                           color: Colors.transparent,
//                           child: Icon(
//                             FontAwesomeIcons.close,
//                             color: normalBgColor2,
//                             size: 18,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             );
//           }).toList(),
//         )
//       ],
//     );
//   });
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_skill_filter_page.dart';

import '../../../../models/course_model.dart';
import '../../../../models/skill_model.dart';
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
                  resetAllData();
                  closePage();
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
                onPress: () async {},
                title: "投稿",
              ),
            ),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            inputField(hintText: "標題", editingController: TextEditingController(), fontSzie: ScreenSize.fontSize24),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            inputField(hintText: "大綱", editingController: TextEditingController()),
            SizedBox(height: ScreenSize.fitPxHeight(10)),
            inputField(hintText: "前置需求", editingController: TextEditingController()),
            SizedBox(height: ScreenSize.fitPxHeight(5)),
            const CourseLevelChoicedLabel(),
            SizedBox(height: ScreenSize.fitPxHeight(15)),
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
            ),
            SizedBox(height: ScreenSize.fitPxHeight(15)),
            courseDetailEdit(),
            Column(
              children: [
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
                Column(
                  children: ref.watch(courseEditChapterList).asMap().entries.map((e) {
                    int index = e.key;
                    CourseChapterInfo value = e.value;

                    return CustomExpansionTile(
                      initiallyExpanded: true,
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
                              CourseRichTextEdit(courseEditPageRender: render).show(context);
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
                )
              ],
            )
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
      controller: TextEditingController(),
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

  void resetAllData() {
    ref.read(courseDetailContent.notifier).update((state) => "");
    ref.read(courseEditSkillList.notifier).update((state) => []);
    ref.read(courseEditChapterList.notifier).update((state) => []);
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
