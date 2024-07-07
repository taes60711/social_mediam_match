// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:quill_html_editor/quill_html_editor.dart';
// import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
// import 'package:social_mediam_match/components/utilities/endDrawers/custom_end_drawer.dart';
// import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
// import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
// import 'package:social_mediam_match/components/utilities/title_input.dart';
// import 'package:social_mediam_match/pagemanager/setting/route_controller.dart';
// import 'package:social_mediam_match/provider/course_state.dart';

// import '../../../models/course_model.dart';
// import '../../../models/user_model.dart';
// import '../../utilities/rich_text_view.dart';
// import '../../utilities/style/style_config.dart';

// class CourseEditPage extends StatelessWidget {
//   const CourseEditPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     print("CourseEditPage");
//     return Scaffold(
//       body: Consumer<CourseState>(builder: (context, courseState, _) {
//         CourseModel? courseData =
//             (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['courseData'] as CourseModel?;
//         LoginUser userData = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['userData'] as LoginUser;
//         TextEditingController titleController = context.select((CourseState value) => value.titleController);
//         TextEditingController contentController = context.select((CourseState value) => value.contentController);
//         TextEditingController beforeNeedController = context.select((CourseState value) => value.beforeNeedController);
//         bool isPublic = context.select((CourseState value) => value.isPublic);
//         List<CourseChapterInfo> chapters = context.select((CourseState value) => value.chapters);
//         List<Map<String, dynamic>> skillList = context.select((CourseState value) => value.skillList);
//         List<String> choicedskillList = context.select((CourseState value) => value.choicedskillList);
//         String needLevel = context.select((CourseState value) => value.needLevel);
//         String type = context.select((CourseState value) => value.type);
//         var items = [
//           '0',
//           '1',
//           '2',
//           '3',
//           '4',
//           '5',
//         ];
//         return StatefulWrapper(
//             onInit: () async {
//               await courseState.getSkillListData();
//               if (courseData != null) {
//                 courseState.courseDataInsertToView(courseData);
//               }
//             },
//             child: Scaffold(
//               body: SafeArea(
//                 child: Column(
//                   children: [
//                     const BaseTopBar(
//                       title: "編輯課程",
//                     ),
//                     TitleInput(title: "標題", textController: titleController),
//                     TitleInput(title: "課程大綱", textController: contentController),
//                     TitleInput(title: "課程前需要", textController: beforeNeedController),
//                     Text("類別"),
//                     DropdownButton(
//                       value: type,
//                       icon: const Icon(Icons.keyboard_arrow_down),
//                       items: items.map((String items) {
//                         return DropdownMenuItem(
//                           value: items,
//                           child: Text(items),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         courseState.needLevelChange(newValue ?? "1", "type");
//                       },
//                     ),
//                     Text("課程難度"),
//                     DropdownButton(
//                       value: needLevel,
//                       icon: const Icon(Icons.keyboard_arrow_down),
//                       items: items.map((String items) {
//                         return DropdownMenuItem(
//                           value: items,
//                           child: Text(items),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         courseState.needLevelChange(newValue ?? "1", "needLevel");
//                       },
//                     ),
//                     SizedBox(
//                       height: 100,
//                       child: ListView(
//                         children: skillList.asMap().entries.map((e) {
//                           int index = e.key;
//                           String skillName = e.value["name"];
//                           bool ischoiced = e.value['ischoiced'];
//                           return GestureDetector(
//                             onTap: () {
//                               courseState.choiceSkill(index);
//                             },
//                             child: Text(
//                               skillName,
//                               style: TextStyle(color: ischoiced ? normalBgColor : normalBgColor2),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Text("章節"),
//                         ElevatedButton(
//                           onPressed: () {
//                             courseState.addChapter();
//                           },
//                           child: Text("Plus"),
//                         )
//                       ],
//                     ),
//                     Expanded(
//                       child: ListView(
//                         physics: const BouncingScrollPhysics(),
//                         children: chapters.asMap().entries.map((e) {
//                           int index = e.key;
//                           CourseChapterInfo chapter = e.value;
//                           return ExpansionTile(
//                             title: Row(
//                               children: [
//                                 Expanded(
//                                   child: Text("章節 ${chapter.chapter}"),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     TextEditingController linkTextController = TextEditingController();
//                                     QuillEditorController controller = QuillEditorController();
//                                     showDialog(
//                                       context: context,
//                                       barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
//                                       builder: (BuildContext context) {
//                                         return EndDrawer(
//                                           onDismissed: () => RouteOptions.pop(),
//                                           child: Scaffold(
//                                             body: SafeArea(
//                                                 child: Column(
//                                               children: [
//                                                 ElevatedButton(
//                                                     onPressed: () {
//                                                       Navigator.pop(context);
//                                                     },
//                                                     child: Text("back")),
//                                                 TitleInput(title: 'Link Text', textController: linkTextController),
//                                                 Expanded(child: RichTextEditor(controller: controller, content: "")),
//                                                 ElevatedButton(
//                                                   onPressed: () async {
//                                                     String text = await controller.getText();
//                                                     String content = '{"text":"${linkTextController.text}","url":"$text"}';

//                                                     courseState.addChapterContent(index, content);
//                                                     Navigator.pop(context);
//                                                   },
//                                                   child: Text("send"),
//                                                 ),
//                                               ],
//                                             )),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   },
//                                   child: Text("add"),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     courseState.deleteChapter(index);
//                                   },
//                                   child: Text("delete"),
//                                 )
//                               ],
//                             ),
//                             children: chapters[index].content.asMap().entries.map((e) {
//                               int contentIndex = e.key;
//                               String content = e.value;

//                               int startIndex = '{"text":"'.length;
//                               int endIndex = content.indexOf('","');
//                               int startUrlIndex = content.indexOf('"url":"') + '"url":"'.length;
//                               int endUrlIndex = content.indexOf('"}');
//                               String chapterText = content.substring(startIndex, endIndex);
//                               String chapterUrl = content.substring(startUrlIndex, endUrlIndex);

//                               return Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 5),
//                                 child: Row(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(right: 5),
//                                       child: Icon(
//                                         Icons.ondemand_video,
//                                         color: normalBgColor2,
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           showGeneralDialog(
//                                               barrierColor: Colors.black.withOpacity(0.7),
//                                               transitionBuilder: (context, a1, a2, widget) {
//                                                 return Transform.scale(
//                                                   scale: a1.value,
//                                                   child: Opacity(
//                                                     opacity: a1.value,
//                                                     child: Scaffold(
//                                                       body: SafeArea(
//                                                         child: SingleChildScrollView(
//                                                           child: Column(
//                                                             children: [
//                                                               Text(chapterText),
//                                                               GestureDetector(
//                                                                 onTap: () {
//                                                                   Navigator.of(context).pop();
//                                                                 },
//                                                                 child: Container(
//                                                                   alignment: Alignment.topRight,
//                                                                   margin: const EdgeInsets.only(right: 20, bottom: 20),
//                                                                   child: Icon(
//                                                                     Icons.close,
//                                                                     color: normalBgColor2,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               RichTextView(content: chapterUrl)
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                               transitionDuration: Duration(milliseconds: 200),
//                                               barrierDismissible: true,
//                                               barrierLabel: '',
//                                               context: context,
//                                               pageBuilder: (context, animation1, animation2) {
//                                                 return Container();
//                                               });
//                                         },
//                                         child: Text(
//                                           chapterText,
//                                           style: TextStyle(color: googleColor, decoration: TextDecoration.underline),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ),
//                                     ElevatedButton(
//                                         onPressed: () {
//                                           courseState.deleteChapterContent(index, contentIndex);
//                                         },
//                                         child: Text("X")),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             CourseCreateModel courseUpdateData = CourseCreateModel(
//                               createdBy: userData.uid,
//                               title: titleController.text,
//                               needLevel: int.parse(needLevel),
//                               content: contentController.text,
//                               beforeNeed: beforeNeedController.text,
//                               prStory: "",
//                               chapterList: chapters,
//                               courseLearningSkills: choicedskillList,
//                               type: int.parse(type),
//                               isPublic: isPublic,
//                             );
//                             inspect(courseUpdateData);
//                             if (courseData != null) {
//                               courseState.updateCourse(
//                                   courseId: courseData.id, courseUpdateData: courseUpdateData, userData: userData);
//                             } else {
//                               courseState.createCourse(createCourseData: courseUpdateData);
//                             }
//                           },
//                           child: Text("createCourse"),
//                         ),
//                         Text("公開"),
//                         Checkbox(
//                             value: isPublic,
//                             onChanged: (value) {
//                               courseState.isPublicOnChange();
//                             }),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ));
//       }),
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/skill_bar.dart';
import 'package:social_mediam_match/components/home/coursePage/course_edit_page/course_rich_text_edit.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/skill_setting_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/rich_text_view.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/provider/corse_view_model.dart';

import '../../../../models/course_model.dart';
import '../../../../provider/course_provider.dart';

import '../../../utilities/basic_top_bar.dart';
import '../../../utilities/endDrawers/course_edit_skill_choice_end_drawer.dart';

class CourseEditPage extends StatelessWidget {
  const CourseEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    CourseModel? courseData = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['courseData'] as CourseModel?;
    return StatefulWrapper(
      onInit: () async {
        await CourseViewModel(courseContext: context).courseEditInit(courseData: courseData);
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  const BaseTopBar(
                    title: "編輯課程",
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(builder: (context) {
                            TextEditingController titleController =
                                context.select((CourseProvider value) => value.titleController);
                            return TitleInput(title: "標題", textController: titleController);
                          }),
                          Builder(builder: (context) {
                            TextEditingController contentController =
                                context.select((CourseProvider value) => value.contentController);
                            String contentText = context.select((CourseProvider value) => value.contentText);
                            return MultiTitleInput(
                              title: "課程大綱",
                              textController: contentController,
                              displayText: contentText,
                              multiOnChange: (String value) => context.read<CourseProvider>().contentOnChange(value),
                            );
                          }),
                          Builder(builder: (context) {
                            TextEditingController beforeNeedController =
                                context.select((CourseProvider value) => value.beforeNeedController);
                            String beforeNeedText = context.select((CourseProvider value) => value.beforeNeedText);
                            return MultiTitleInput(
                              title: "課程前需要",
                              textController: beforeNeedController,
                              displayText: beforeNeedText,
                              multiOnChange: (String value) => context.read<CourseProvider>().beforeNeedOnChange(value),
                            );
                          }),
                          Builder(builder: (context) {
                            var items = ['0', '1', '2', '3', '4', '5'];
                            String needLevel = context.select((CourseProvider value) => value.needLevel);
                            return Row(
                              children: [
                                const Text("課程難度"),
                                const SizedBox(width: 10),
                                DropdownButton(
                                  value: needLevel,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    context.read<CourseProvider>().needLevelChange(newValue ?? "1", "needLevel");
                                  },
                                ),
                              ],
                            );
                          }),
                          Builder(builder: (context) {
                            List<String> choicedSkillList = context.watch<CourseProvider>().choicedSkillList;
                            return GestureDetector(
                              onTap: () {
                                openCoursEditSkillEndDrawer(context: context);
                              },
                              child: Container(
                                width: ScreenSize.width,
                                color: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("學習的技能"),
                                    const SizedBox(height: 5),
                                    choicedSkillList.isEmpty
                                        ? Container(
                                            margin: const EdgeInsets.only(right: 5, bottom: 5),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: normalBgColor,
                                            ),
                                            child: Text(
                                              tr("noskillData"),
                                              style: TextStyle(color: normalTextColor, fontSize: 14),
                                            ),
                                          )
                                        : skillBar(SkillEndDrawerType.close, courseSkillData: choicedSkillList),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const Row(
                            children: [
                              Expanded(
                                child: Text("詳細介紹 >"),
                              ),
                              Text("編輯 "),
                              SizedBox(width: 10)
                            ],
                          ),
                          Builder(builder: (context) {
                            List<CourseChapterInfo> chapters = context.watch<CourseProvider>().chapters;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Text("章節"),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        context.read<CourseProvider>().addChapter();
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: normalBgColor2,
                                        ),
                                        child: const Icon(
                                          FontAwesomeIcons.plus,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: chapters.asMap().entries.map((e) {
                                    int index = e.key;
                                    CourseChapterInfo chapter = e.value;
                                    return ExpansionTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text("章節 ${chapter.chapter}"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: false,
                                                context: context,
                                                backgroundColor: Colors.white,
                                                useSafeArea: true,
                                                builder: (builder) {
                                                  return FractionallySizedBox(
                                                    heightFactor: 1,
                                                    child: CourseRichTextEdit(index: index, courseContext: context),
                                                  );
                                                },
                                              );
                                            },
                                            child: Text("add"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              context.read<CourseProvider>().deleteChapter(index);
                                            },
                                            child: Text("delete"),
                                          )
                                        ],
                                      ),
                                      children: chapters[index].content.asMap().entries.map((e) {
                                        int contentIndex = e.key;
                                        String content = e.value;

                                        int startIndex = '{"text":"'.length;
                                        int endIndex = content.indexOf('","');
                                        int startUrlIndex = content.indexOf('"url":"') + '"url":"'.length;
                                        int endUrlIndex = content.indexOf('"}');
                                        String chapterText = content.substring(startIndex, endIndex);
                                        String chapterUrl = content.substring(startUrlIndex, endUrlIndex);

                                        return Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 5),
                                                child: Icon(
                                                  Icons.ondemand_video,
                                                  color: normalBgColor2,
                                                ),
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      enableDrag: false,
                                                      context: context,
                                                      backgroundColor: Colors.white,
                                                      useSafeArea: true,
                                                      builder: (builder) {
                                                        return FractionallySizedBox(
                                                          heightFactor: 1,
                                                          child: Scaffold(
                                                            body: Column(
                                                              children: [
                                                                BaseTopBar(title: chapterText),
                                                                Expanded(
                                                                  child: SingleChildScrollView(
                                                                    child: RichTextView(content: chapterUrl),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                    chapterText,
                                                    style: TextStyle(color: googleColor, decoration: TextDecoration.underline),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    context.read<CourseProvider>().deleteChapterContent(index, contentIndex);
                                                  },
                                                  child: Text("X")),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }).toList(),
                                )
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    bool isPublic = context.select((CourseProvider value) => value.isPublic);
                    return Row(
                      children: [
                        CustomButton(
                          title: "保存",
                          width: 150,
                          verticalMargin: 8,
                          backgroundColor: normalBgColor,
                          onPress: () {},
                        ),
                        const SizedBox(width: 10),
                        const Text("公開"),
                        Checkbox(
                            value: isPublic,
                            onChanged: (value) {
                              context.read<CourseProvider>().isPublicOnChange();
                            }),
                      ],
                    );
                  }),
                ],
              ),
            ),
            coursEditSkillEndDrawer(),
          ],
        ),
      ),
    );
  }
}
