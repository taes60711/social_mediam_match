// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_mediam_match/components/home/userPage/myCourse/added_courses_page.dart';
// import 'package:social_mediam_match/components/home/userPage/myCourse/created_courses_page.dart';
// import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
// import 'package:social_mediam_match/components/utilities/endDrawers/course_manager_end_drawer.dart';
// import 'package:social_mediam_match/models/course_model.dart';
// import '../../../utilities/apiListView/base_api_list_provider.dart';
// import '../../../utilities/endDrawers/course_detail_end_drawer.dart';
// import '../../../utilities/endDrawers/user_detail_end_drawer.dart';
// import '../../../utilities/style/style_config.dart';

// class MyCourses extends StatelessWidget {
//   const MyCourses({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 const BaseTopBar(
//                   title: "技術分享",
//                 ),
//                 Expanded(
//                   child: DefaultTabController(
//                     length: 2,
//                     child: Scaffold(
//                       appBar: TabBar(
//                         tabs: const [
//                           SizedBox(
//                             height: 25,
//                             child: Tab(text: '已加入的分享文章'),
//                           ),
//                           SizedBox(
//                             height: 25,
//                             child: Tab(text: '已創建的分享文章'),
//                           ),
//                         ],
//                         isScrollable: true,
//                         indicator: UnderlineTabIndicator(
//                           borderSide: BorderSide(width: 1.0, color: normalBgColor),
//                           insets: const EdgeInsets.symmetric(horizontal: 10),
//                         ),
//                         labelPadding: const EdgeInsets.only(top: 5, left: 10, right: 10),
//                         labelColor: normalBgColor2,
//                       ),
//                       body: Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: TabBarView(
//                           children: [
//                             MultiProvider(
//                               providers: [
//                                 ChangeNotifierProvider(create: (_) => BaseAPIListProvider<CourseModel>()),
//                               ],
//                               child: const AddedCoursesPage(),
//                             ),
//                             MultiProvider(
//                               providers: [
//                                 ChangeNotifierProvider(create: (_) => BaseAPIListProvider<CourseModel>()),
//                               ],
//                               child: const CreatedCoursesPage(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // courseDetailEndDrawer(),
//             courseManagerEndDrawer(),
//             userDetailEndDrawer(),
//           ],
//         ),
//       ),
//     );
//   }
// }
