import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../service/db_service.dart';

class Firends extends StatelessWidget {
  const Firends({super.key});

  Widget friendList() {
    DBService dbService = DBService();
    return SafeArea(
      child: StreamBuilder(
          stream: dbService.getChatRoomListData(""),
          builder: (context, snapshots) {
            log("${snapshots.connectionState}");
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            } else {
              if (snapshots.hasData) {
                List<dynamic> friendList =
                    snapshots.data["chatroom"]["friends"];
                return Column(
                  children: friendList.map((e) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.yellow,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.blue,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Color.fromARGB(221, 172, 139, 139),
                                      child: Text("$e"),
                                    ),
                                    Text("dataasdsadasdsadasdsad"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Container();
              }
            }
          }),
    );
  }

  Widget groupList() {
    DBService dbService = DBService();
    return SafeArea(
      child: StreamBuilder(
          stream: dbService.getChatRoomListData(""),
          builder: (context, snapshots) {
            log("${snapshots.connectionState}");
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            } else {
              if (snapshots.hasData) {
                List<dynamic> friendList = snapshots.data["chatroom"]["groups"];
                return Column(
                  children: friendList.map((e) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.yellow,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.blue,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Color.fromARGB(221, 172, 139, 139),
                                      child: Text("$e"),
                                    ),
                                    Text("dataasdsadasdsadasdsad"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Container();
              }
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: '好友'),
                Tab(text: '群組'),
              ],
            ),
          ),
          body: TabBarView(
            children: [friendList(), groupList()],
          )),
    );
  }
}
