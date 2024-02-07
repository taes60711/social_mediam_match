import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_mediam_match/components/home/chat.dart';
import 'package:social_mediam_match/components/home/firendsPage/firends.dart';
import 'package:social_mediam_match/components/home/user_page.dart';
import 'package:social_mediam_match/service/db_service.dart';
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
    Firends(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.mobile_friendly),
            label: '好友',
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
    DBService dbService = DBService();

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
            dbService.getDataAtOnce("");
          },
          child: const Text("データ取得"),
        ),
        ElevatedButton(
          onPressed: () {
            log("データ入る");
            dbService.addData("taes60711@gmail.com");
          },
          child: const Text("データ増える"),
        ),
        StreamBuilder(
            stream: dbService.getPostData(),
            builder: (context, snapshots) {
              log("${snapshots.connectionState}");
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              } else {
                if (snapshots.hasData) {
                  log("${snapshots.data}");
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshots.data!.length,
                        itemBuilder: (context, index) {
                          dynamic data = snapshots.data![index];
                          List<dynamic> commentdata = data["comment"].toList();

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.black12,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text("使用者：${data["mainuser"]}"),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("文章內容："),
                                          Text("${data["content"]}"),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("留言:"),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children:
                                                      commentdata.map((r) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "Level : ${commentdata.indexOf(r)}"),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 30,
                                                              height: 30,
                                                              color: Colors
                                                                  .deepPurpleAccent,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                                "使用者：${r["user"]}"),
                                                          ],
                                                        ),
                                                        Text(
                                                            "內容：${r["content"]}")
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return const Text("No Data");
                }
              }
            }),
      ],
    );
  }
}
