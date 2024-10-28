// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/utilities/background_widget.dart';
// import 'package:social_mediam_match/components/utilities/custom_button.dart';
// import 'package:social_mediam_match/models/course_model.dart';
// import 'package:social_mediam_match/models/user_model.dart';
// import 'package:social_mediam_match/provider/corse_view_model.dart';

// import '../../../provider/account/user_provider.dart';
// import '../../../provider/course_provider.dart';
// import '../../account/skill_bar.dart';
// import '../../utilities/custom_expansion_title.dart';
// import '../../utilities/endDrawers/skill_setting_end_drawer.dart';
// import '../../utilities/endDrawers/user_detail_end_drawer.dart';
// import '../../utilities/rich_text_view.dart';
// import '../../utilities/style/screen_size.dart';
// import '../../utilities/style/style_config.dart';
// import '../../utilities/user_icon.dart';

// class CourseDetail extends StatelessWidget {
//   const CourseDetail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     CourseModel openedCourse = context.watch<CourseProvider>().choicedCourse;
//     ProfileData userData = context.watch<UserProvider>().userData;

//     return BackgroundWidget(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//         child: Builder(builder: (context) {
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       openedCourse.title,
//                       style: const TextStyle(fontSize: 19),
//                     ),
//                     Builder(builder: (context) {
//                       return Visibility(
//                         visible: openedCourse.signUpStatus == "none" &&
//                             !openedCourse.isPublic &&
//                             openedCourse.courseCreateduserInfo.uid != userData.uid,
//                         child: TextBtn(
//                           verticalMargin: 5,
//                           btnRadius: 10,
//                           btnWidth: 55,
//                           title: "申請",
//                           onPress: () {
//                             CourseViewModel(courseContext: context).courseSignUp(choicedCourse: openedCourse);
//                           },
//                           titleColor: normalTextColor,
//                           btnColor: googleButtonColor.withOpacity(0.8),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//                 Container(margin: const EdgeInsets.all(5), width: ScreenSize.width, height: 0.3, color: hintTextColor),
//                 Text(
//                   "課程類別: ${openedCourse.type}",
//                   style: TextStyle(fontSize: 12, color: hintTextColor),
//                 ),
//                 Container(margin: const EdgeInsets.all(5), width: ScreenSize.width, height: 0.3, color: hintTextColor),
//                 const Text(
//                   "課程前需求:",
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Container(
//                   width: ScreenSize.width,
//                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//                   decoration: BoxDecoration(
//                     color: hintTextColor.withAlpha(50),
//                     borderRadius: BorderRadius.circular(3),
//                   ),
//                   child: Text(openedCourse.beforeNeed),
//                 ),
//                 Container(margin: const EdgeInsets.all(5), width: ScreenSize.width, height: 0.3, color: hintTextColor),
//                 const Text(
//                   "課程內容:",
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Container(
//                   width: ScreenSize.width,
//                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//                   decoration: BoxDecoration(
//                     color: hintTextColor.withAlpha(50),
//                     borderRadius: BorderRadius.circular(3),
//                   ),
//                   child: Text(openedCourse.content),
//                 ),
//                 const SizedBox(height: 5),
//                 const Text(
//                   "學習技能:",
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: skillBar(
//                         SkillEndDrawerType.close,
//                         courseSkillData: openedCourse.courseLearningSkills,
//                         fontSize: 12,
//                       ),
//                     ),
//                     Text(
//                       "難度: ${openedCourse.needLevel}",
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 Container(margin: const EdgeInsets.all(5), width: ScreenSize.width, height: 0.3, color: hintTextColor),
//                 GestureDetector(
//                   onTap: () {
//                     openUserDetailEndDrawer(context: context, otherUserData: openedCourse.courseCreateduserInfo);
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//                     decoration: BoxDecoration(color: googleColor.withAlpha(150), borderRadius: BorderRadius.circular(3)),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               "作成者 : ",
//                               style: TextStyle(fontSize: 14),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 5),
//                               child: UserIcon(
//                                 iconSize: 35,
//                                 image: openedCourse.courseCreateduserInfo.image,
//                               ),
//                             ),
//                             Text(
//                               openedCourse.courseCreateduserInfo.name != ""
//                                   ? openedCourse.courseCreateduserInfo.name ?? ""
//                                   : openedCourse.courseCreateduserInfo.email,
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           "最終更新日 : ${openedCourse.postTime}",
//                           style: TextStyle(color: normalBgColor2, fontSize: 13),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Builder(builder: (context) {
//                   List<CourseChapterInfo> chapterList = openedCourse.chapterList;
//                   return Column(
//                     children: [
//                       CustomExpansionTile(
//                         initiallyExpanded: openedCourse.signUpStatus == "added" || openedCourse.isPublic,
//                         title: const Text("詳細介紹"),
//                         collapsedTrailingWidget: const Icon(Icons.keyboard_arrow_up),
//                         expandedTrailingWidget: const Icon(Icons.keyboard_arrow_down),
//                         children: <Widget>[
//                           RichTextView(content: openedCourse.prStory),
//                         ],
//                       ),
//                       Visibility(
//                         visible: openedCourse.isPublic || openedCourse.signUpStatus == "added",
//                         child: Column(
//                           children: openedCourse.chapterList.asMap().entries.map((e) {
//                             int index = e.key;
//                             CourseChapterInfo chapterInfo = e.value;
//                             return ExpansionTile(
//                               title: Text(chapterInfo.chapterName),
//                               children: [
//                                 SizedBox(
//                                   width: ScreenSize.width,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: chapterList[index].content.map((e) {
//                                       String content = e;
//                                       int startIndex = '{"text":"'.length;
//                                       int endIndex = content.indexOf('","');
//                                       int startUrlIndex = content.indexOf('"url":"') + '"url":"'.length;
//                                       int endUrlIndex = content.indexOf('"}');
//                                       String chapterText = content.substring(startIndex, endIndex);
//                                       String chapterUrl = content.substring(startUrlIndex, endUrlIndex);

//                                       return Padding(
//                                         padding: const EdgeInsets.symmetric(vertical: 5),
//                                         child: Row(
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(right: 5),
//                                               child: Icon(
//                                                 FontAwesomeIcons.fileCode,
//                                                 color: normalBgColor2,
//                                               ),
//                                             ),
//                                             Expanded(
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   CourseViewModel(courseContext: context).openCourseChapterContentPage(
//                                                       chapterText: chapterText, chapterUrl: chapterUrl);
//                                                 },
//                                                 child: Text(
//                                                   chapterText,
//                                                   style: TextStyle(color: googleColor, decoration: TextDecoration.underline),
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 )
//                               ],
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   );
//                 })
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';

class CourseDetailPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    return const Column(
      children: [
        Text(
          "data",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
