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
                          const SizedBox(height: 15),
                          Builder(builder: (context) {
                            String prStory = context.select((CourseProvider value) => value.prStory);
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    CourseViewModel(courseContext: context).openRichEditPage(prStory: prStory);
                                  },
                                  child: const Row(
                                    children: [
                                      Expanded(
                                        child: Text("詳細介紹 "),
                                      ),
                                      Icon(Icons.edit),
                                      Text("編輯 "),
                                      SizedBox(width: 10)
                                    ],
                                  ),
                                ),
                                RichTextView(content: prStory),
                              ],
                            );
                          }),
                          const SizedBox(height: 15),
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
                                              CourseViewModel(courseContext: context).openRichEditPage(chapterIndex: index);
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
                          onPress: () async {
                            int? id;
                            if (courseData != null) {
                              id = courseData.id;
                            }
                            CourseViewModel(courseContext: courseContext).courseCreateOrUpdate(courseId: id);
                          },
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
