import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_exchange_page.dart';
import 'package:social_mediam_match/components/home/coursePage/course_page.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/home/userPage/user_page.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/course_state.dart';
import 'package:social_mediam_match/states/post_state.dart';
import 'package:social_mediam_match/states/skill_exchange_state.dart';

import '../../states/friend_state.dart';
import 'postPage/forum.dart';

class Home extends StatefulWidget {
  final LoginUser userData;
  final FriendState friendState;
  const Home({super.key, required this.userData, required this.friendState});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void gotoFriendPage() {
    setState(() {
      _selectedIndex = 3;
    });
  }

  void gotoCourserPage() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      ChangeNotifierProvider(
        create: (_) => PostState(),
        child: Forum(
          userData: widget.userData,
          gotoFriendPage: gotoFriendPage,
          gotoCoursePage: gotoCourserPage,
        ),
      ),
      SkillExChangePage(
        userData: widget.userData,
        gotoFriendPage: gotoFriendPage,
      ),
      ChangeNotifierProvider(
        create: (_) => CourseState(),
        child: CoursePage(
          userData: widget.userData,
          gotoFriendPage: gotoFriendPage,
        ),
      ),
      FirendsPage(userData: widget.userData),
      UserPage(
        userData: widget.userData,
        friendState: widget.friendState,
        gotoFriendPage: gotoFriendPage,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: '主頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidFaceLaugh),
            label: '技能交換',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.bookOpenReader),
            label: '課程',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidComments),
            label: '聊天室',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidUser),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (value) {
          setState(() {
            print("Page Index : $value");
            if (value != 1) {
              Provider.of<SkillExChangeState>(context, listen: false).skillExchangePageDisPose();
            }
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
