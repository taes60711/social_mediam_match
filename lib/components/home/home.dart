import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_exchange_page.dart';
import 'package:social_mediam_match/components/home/course.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/home/postPage/post_page.dart';
import 'package:social_mediam_match/components/home/userPage/user_page.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/course_state.dart';
import 'package:social_mediam_match/states/post_state.dart';
import 'package:social_mediam_match/states/skill_exchange_state.dart';

import '../../states/friend_state.dart';

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

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      ChangeNotifierProvider(
        create: (_) => PostState(),
        child: PostPage(userData: widget.userData, gotoFriendPage: gotoFriendPage),
      ),
      SkillExChangePage(userData: widget.userData, gotoFriendPage: gotoFriendPage),
      ChangeNotifierProvider(
        create: (_) => CourseState(),
        child: Course(
          userData: widget.userData,
        ),
      ),
      FirendsPage(userData: widget.userData),
      UserPage(
        userData: widget.userData,
        friendState: widget.friendState,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '技能交換',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '課程',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mobile_friendly),
            label: '聊天室',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (value) {
          setState(() {
            print("Page Index : $value");
            if (value != 1) {
              if (widget.friendState.isFriend) {
                widget.friendState.UserDetailPageClose(widget.userData.uid);
              }
              Provider.of<SkillExChangeState>(context, listen: false).skillExchangePageDisPose();
            }
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
