import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_mediam_match/components/home/chat.dart';
import 'package:social_mediam_match/components/home/course.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends.dart';
import 'package:social_mediam_match/components/home/home_page.dart';
import 'package:social_mediam_match/components/home/userPage/user_page.dart';
import 'package:social_mediam_match/models/user_model.dart';

class Home extends StatefulWidget {
  final LoginUser? userData;
  const Home({super.key, this.userData});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomePage(),
      Chat(),
      Course(),
      Firends(),
      UserPage(
        userData: widget.userData,
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
            label: '留言板',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '告示欄',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '課程',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mobile_friendly),
            label: '好友',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: '使用者',
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
