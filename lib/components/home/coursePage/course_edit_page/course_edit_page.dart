import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/account/skill_bar.dart';
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
import '../../../utilities/custom_expansion_title.dart';
import '../../../utilities/endDrawers/course_edit_skill_choice_end_drawer.dart';

class CourseEditPage extends StatelessWidget {
  const CourseEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    CourseModel? courseData = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['courseData'] as CourseModel?;
    BuildContext courseContext = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['context'] as BuildContext;
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            courseTitleEdit(),
                            courseContentEdit(),
                            courseBeforeNeedEdit(),
                            courseLeveEdit(),
                            courseLearningSkillEdit(),
                            const SizedBox(height: 15),
                            courseDetailEdit(),
                            const SizedBox(height: 15),
                            courseChapterEdit(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        TextBtn(
                          title: "保存",
                          btnWidth: 150,
                          verticalMargin: 8,
                          btnColor: normalBgColor,
                          onPress: () async {
                            int? id;
                            if (courseData != null) {
                              id = courseData.id;
                            }
                            CourseViewModel(courseContext: courseContext).courseCreateOrUpdate(courseId: id);
                          },
                        ),
                        Builder(builder: (context) {
                          bool isPublic = context.select((CourseProvider value) => value.isPublic);
                          return GestureDetector(
                            onTap: () {
                              context.read<CourseProvider>().isPublicOnChange();
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
                                  onChanged: (value) {},
                                ),
                                const Text("公開"),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
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

Widget courseTitleEdit() {
  return Builder(builder: (context) {
    TextEditingController titleController = context.select((CourseProvider value) => value.titleController);
    return TitleInput(
      title: "標題",
      textController: titleController,
      padding: EdgeInsets.zero,
    );
  });
}

Widget courseContentEdit() {
  return Builder(builder: (context) {
    TextEditingController contentController = context.select((CourseProvider value) => value.contentController);
    String contentText = context.select((CourseProvider value) => value.contentText);
    return MultiTitleInput(
      title: "課程大綱",
      textController: contentController,
      displayText: contentText,
      padding: EdgeInsets.zero,
      multiOnChange: (String value) => context.read<CourseProvider>().contentOnChange(value),
    );
  });
}

Widget courseBeforeNeedEdit() {
  return Builder(builder: (context) {
    TextEditingController beforeNeedController = context.select((CourseProvider value) => value.beforeNeedController);
    String beforeNeedText = context.select((CourseProvider value) => value.beforeNeedText);
    return MultiTitleInput(
      title: "課程前需要",
      textController: beforeNeedController,
      displayText: beforeNeedText,
      padding: EdgeInsets.zero,
      multiOnChange: (String value) => context.read<CourseProvider>().beforeNeedOnChange(value),
    );
  });
}

Widget courseLeveEdit() {
  return Builder(builder: (context) {
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
  });
}

Widget courseLearningSkillEdit() {
  return Builder(builder: (context) {
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
  });
}

Widget courseDetailEdit() {
  return Builder(builder: (context) {
    String prStory = context.select((CourseProvider value) => value.prStory);
    return CustomExpansionTile(
      initiallyExpanded: true,
      title: Row(
        children: [
          const Expanded(
            child: Text("詳細介紹"),
          ),
          GestureDetector(
            onTap: () {
              CourseViewModel(courseContext: context).openRichEditPage(prStory: prStory);
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  size: 18,
                  color: normalBgColor,
                ),
                const SizedBox(width: 5),
                Text(
                  "編輯",
                  style: TextStyle(
                    color: normalBgColor2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      children: <Widget>[
        RichTextView(content: prStory),
      ],
    );
  });
}

Widget courseChapterEdit() {
  return Builder(builder: (context) {
    List<CourseChapterInfo> chapters = context.watch<CourseProvider>().chapters;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.read<CourseProvider>().addChapter();
          },
          child: Row(
            children: [
              const Text("章節"),
              Container(
                width: 30,
                height: 30,
                color: Colors.transparent,
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: normalBgColor2,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: chapters.asMap().entries.map((e) {
            int index = e.key;
            CourseChapterInfo chapter = e.value;
            return ExpansionTile(
              initiallyExpanded: true,
              title: Row(
                children: [
                  Expanded(
                    child: Text("章節 ${chapter.chapter}"),
                  ),
                  GestureDetector(
                    onTap: () {
                      CourseViewModel(courseContext: context).openRichEditPage(chapterIndex: index);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: normalBgColor2,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      context.read<CourseProvider>().deleteChapter(index);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: normalBgColor2,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.minus,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
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
                  padding: const EdgeInsets.symmetric(vertical: 5),
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
                            CourseViewModel(courseContext: context).openCourseChapterContentPage(
                              chapterText: chapterText,
                              chapterUrl: chapterUrl,
                            );
                          },
                          child: Text(
                            chapterText,
                            style: TextStyle(color: googleColor, decoration: TextDecoration.underline),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<CourseProvider>().deleteChapterContent(index, contentIndex);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          color: Colors.transparent,
                          child: Icon(
                            FontAwesomeIcons.close,
                            color: normalBgColor2,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }).toList(),
        )
      ],
    );
  });
}
