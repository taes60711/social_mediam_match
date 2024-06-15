import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_exchange_page.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/home/userPage/user_page.dart';
import 'package:social_mediam_match/states/course_state.dart';
import 'package:social_mediam_match/states/post_state.dart';
import 'package:social_mediam_match/states/skill_exchange_state.dart';
import '../../pageManager/enum/bottom_bar_path.dart';
import '../../pageManager/provider/bottom_bar_controller_provider.dart';

import '../../pagemanager/setting/bottom_bar_manager.dart';
import 'postPage/forum.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      ChangeNotifierProvider(
        create: (_) => PostState(),
        child: const Forum(),
      ),
      const SkillExChangePage(),
      ChangeNotifierProvider(
        create: (_) => CourseState(),
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
