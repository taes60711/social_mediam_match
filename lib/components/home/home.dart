import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/skillExChangePage/skill_exchange_page.dart';
import 'package:social_mediam_match/components/home/course.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends_page.dart';
import 'package:social_mediam_match/components/home/postPage/post_page.dart';
import 'package:social_mediam_match/components/home/userPage/user_page.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/states/post_state.dart';

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

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      ChangeNotifierProvider(
        create: (_) => PostState(),
        child: PostPage(userData: widget.userData),
      ),
      SkillExChangePage(userData: widget.userData),
      Course(),
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
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}
