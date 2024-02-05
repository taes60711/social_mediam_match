import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_mediam_match/components/home/chat.dart';
import 'package:social_mediam_match/components/home/user_page.dart';
import 'package:social_mediam_match/service/fb_service.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FbService fireBaseService = FbService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Chat(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '主要',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '使用者',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (value) {
          setState(() {
            log("$value");
            _selectedIndex = value;
          });
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FbService fireBaseService = FbService();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<List<dynamic>> getData() {
      //ReadData Sample
      final stream = firestore.collection("users").snapshots();
      inspect(stream.map((e) => e.docs.map((e) => e.data()).toList()));
      return stream.map((e) => e.docs.map((e) => e.data()).toList());
    }

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            fireBaseService.signOut();
            Navigator.of(context)
                .popUntil((route) => route.settings.name == "/");
          },
          child: const Text("登出"),
        ),
        ElevatedButton(
          onPressed: () {
            getData();
          },
          child: const Text("取得データ"),
        ),
      ],
    );
  }
}
