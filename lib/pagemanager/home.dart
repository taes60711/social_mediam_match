import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_change_page.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/home/userPage/user_page.dart';
import 'package:social_mediam_match/models/course_model.dart';
import 'package:social_mediam_match/provider/home/skill_change_view_provider.dart';
import 'package:social_mediam_match/provider/post/post_provider.dart';
import 'package:social_mediam_match/states/course_state.dart';
import '../models/user_model.dart';
import '../provider/post/post_comment_provider.dart';
import 'enum/bottom_bar_path.dart';

import 'setting/bottom_bar_controller_provider.dart';
import 'setting/bottom_bar_manager.dart';
import '../components/utilities/apiListView/base_api_list_provider.dart';
import '../components/home/postPage/post_page_forum.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PostProvider()),
          ChangeNotifierProvider(create: (_) => PostCommentProvider()),
        ],
        child: const PostPageForum(),
      ),
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SkillChangeProvider()),
          ChangeNotifierProvider(create: (_) => BaseAPIListProvider<LoginUser>()),
        ],
        child: const SkillChangePage(),
      ),
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CourseState()),
          ChangeNotifierProvider(create: (_) => BaseAPIListProvider<CourseModel>()),
        ],
        child: const CoursePage(),
      ),
      const FirendsPage(),
      const UserPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: widgetOptions.elementAt(context.watch<BottomBarControllerProvider>().index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomBarItems,
        currentIndex: context.watch<BottomBarControllerProvider>().index,
        selectedItemColor: Colors.amber[800],
        onTap: (value) {
          BottomBarPath choicedPath = BottomBarPath.home;
          for (var element in BottomBarPath.values) {
            if (element.path == value) {
              choicedPath = element;
            }
          }
          context.read<BottomBarControllerProvider>().bottomBarPageChange(choicedPath);
        },
      ),
    );
  }
}
