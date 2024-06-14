import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_exchange_page.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/home/userPage/user_page.dart';
import 'package:social_mediam_match/route_options.dart';
import 'package:social_mediam_match/states/course_state.dart';
import 'package:social_mediam_match/states/post_state.dart';
import 'package:social_mediam_match/states/skill_exchange_state.dart';
import '../../route_manager.dart';
import '../../states/friend_state.dart';
import 'postPage/forum.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void gotoFriendPage() {
    context.read<BottomBarControllerProvider>().bottomBarPageChange(3);
  }

  void gotoCourserPage() {
    context.read<BottomBarControllerProvider>().bottomBarPageChange(2);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      ChangeNotifierProvider(
        create: (_) => PostState(),
        child: Forum(
          gotoFriendPage: gotoFriendPage,
          gotoCoursePage: gotoCourserPage,
        ),
      ),
      SkillExChangePage(
        gotoFriendPage: gotoFriendPage,
      ),
      ChangeNotifierProvider(
        create: (_) => CourseState(),
        child: CoursePage(
          gotoFriendPage: gotoFriendPage,
        ),
      ),
      const FirendsPage(),
      UserPage(
        gotoFriendPage: gotoFriendPage,
      ),
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
          context.read<BottomBarControllerProvider>().bottomBarPageChange(value);
          setState(() {
            if (value != 1) {
              Provider.of<SkillExChangeState>(context, listen: false).skillExchangePageDisPose();
            }
          });
        },
      ),
    );
  }
}
