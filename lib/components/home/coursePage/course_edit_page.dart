import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/rich_text_editor.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/title_input.dart';
import 'package:social_mediam_match/states/course_state.dart';

import '../../../models/course_model.dart';
import '../../../models/user_model.dart';
import '../../utilities/custom_end_drawer.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/style_config.dart';

class CourseEditPage extends StatelessWidget {
  const CourseEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("CourseEditPage");
    return Scaffold(
      body: Consumer<CourseState>(builder: (context, courseState, _) {
        CourseModel? courseData =
            (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['courseData'] as CourseModel?;
        LoginUser userData = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['userData'] as LoginUser;
        TextEditingController titleController = context.select((CourseState value) => value.titleController);
        TextEditingController contentController = context.select((CourseState value) => value.contentController);
        TextEditingController beforeNeedController = context.select((CourseState value) => value.beforeNeedController);
        bool isPublic = context.select((CourseState value) => value.isPublic);
        GlobalKey<ScaffoldState> key = context.select((CourseState value) => value.globalKey);
        List<CourseChapterInfo> chapters = context.select((CourseState value) => value.chapters);
        List<Map<String, dynamic>> skillList = context.select((CourseState value) => value.skillList);
        List<String> choicedskillList = context.select((CourseState value) => value.choicedskillList);
        String needLevel = context.select((CourseState value) => value.needLevel);
        String type = context.select((CourseState value) => value.type);
        var items = [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
        ];
        return StatefulWrapper(
            onInit: () async {
              await courseState.getSkillListData();
              if (courseData != null) {
                courseState.courseDataInsertToView(courseData);
              }
            },
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: ScreenSize.width * 0.33,
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        SizedBox(width: ScreenSize.width * 0.33, child: const Center(child: Text("編輯課程"))),
                      ],
                    ),
                    TitleInput(title: "標題", textController: titleController),
                    TitleInput(title: "課程大綱", textController: contentController),
                    TitleInput(title: "課程前需要", textController: beforeNeedController),
                    Text("類別"),
                    DropdownButton(
                      value: type,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        courseState.needLevelChange(newValue ?? "1", "type");
                      },
                    ),
                    Text("課程難度"),
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
                        courseState.needLevelChange(newValue ?? "1", "needLevel");
                      },
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        children: skillList.asMap().entries.map((e) {
                          int index = e.key;
                          String skillName = e.value["name"];
                          bool ischoiced = e.value['ischoiced'];
                          return GestureDetector(
                            onTap: () {
                              courseState.choiceSkill(index);
                            },
                            child: Text(
                              skillName,
                              style: TextStyle(color: ischoiced ? normalBgColor : normalBgColor2),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      children: [
                        Text("章節"),
                        ElevatedButton(
                          onPressed: () {
                            courseState.addChapter();
                          },
                          child: Text("Plus"),
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
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
                                    TextEditingController linkTextController = TextEditingController();
                                    QuillEditorController controller = QuillEditorController();
                                    showDialog(
                                      context: context,
                                      barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
                                      builder: (BuildContext context) {
                                        return CustomEndDrawer(
                                          child: Dismissible(
                                              direction: DismissDirection.startToEnd,
                                              resizeDuration: const Duration(milliseconds: 1),
                                              onDismissed: (_) => Navigator.of(context).pop(),
                                              key: const Key('key'),
                                              child: Scaffold(
                                                body: SafeArea(
                                                    child: Column(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("back")),
                                                    TitleInput(title: 'Link Text', textController: linkTextController),
                                                    Expanded(child: RichTextEditor(controller: controller, content: "")),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        String text = await controller.getText();
                                                        String content = '{"text":"${linkTextController.text}","url":"$text"}';

                                                        courseState.addChapterContent(index, content);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("send"),
                                                    ),
                                                  ],
                                                )),
                                              )),
                                        );
                                      },
                                    );
                                  },
                                  child: Text("add"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    courseState.deleteChapter(index);
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
                                          showGeneralDialog(
                                              barrierColor: Colors.black.withOpacity(0.7),
                                              transitionBuilder: (context, a1, a2, widget) {
                                                return Transform.scale(
                                                  scale: a1.value,
                                                  child: Opacity(
                                                    opacity: a1.value,
                                                    child: Scaffold(
                                                      body: SafeArea(
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Text(chapterText),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Container(
                                                                  alignment: Alignment.topRight,
                                                                  margin: const EdgeInsets.only(right: 20, bottom: 20),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    color: normalBgColor2,
                                                                  ),
                                                                ),
                                                              ),
                                                              RichTextView(content: chapterUrl)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              transitionDuration: Duration(milliseconds: 200),
                                              barrierDismissible: true,
                                              barrierLabel: '',
                                              context: context,
                                              pageBuilder: (context, animation1, animation2) {
                                                return Container();
                                              });
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
                                          courseState.deleteChapterContent(index, contentIndex);
                                        },
                                        child: Text("X")),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            CourseCreateModel courseUpdateData = CourseCreateModel(
                              createdBy: userData.uid,
                              title: titleController.text,
                              needLevel: int.parse(needLevel),
                              content: contentController.text,
                              beforeNeed: beforeNeedController.text,
                              prStory: "",
                              chapterList: chapters,
                              courseLearningSkills: choicedskillList,
                              type: int.parse(type),
                              isPublic: isPublic,
                            );
                            inspect(courseUpdateData);
                            if (courseData != null) {
                              courseState.updateCourse(
                                  courseId: courseData.id, courseUpdateData: courseUpdateData, userData: userData);
                            } else {
                              courseState.createCourse(createCourseData: courseUpdateData);
                            }
                          },
                          child: Text("createCourse"),
                        ),
                        Text("公開"),
                        Checkbox(
                            value: isPublic,
                            onChanged: (value) {
                              courseState.isPublicOnChange();
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
