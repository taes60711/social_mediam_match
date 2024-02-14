import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:social_mediam_match/service/db_service.dart';
import 'package:social_mediam_match/utilities/screen_size.dart';

class Chat extends StatefulWidget {
  Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  DBService dbService = DBService();
  List<String> Allclass = ["english", "app", "arduino", "japanese"];
  List<String> wantSkillFilter = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget drawerPage() {
      return Container(
        width: ScreenSize().width,
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    log("Drawer Close");
                    _key.currentState!.closeEndDrawer();
                  },
                  icon: const Icon(Icons.arrow_back_ios_sharp),
                ),
              ),
              Column(
                  children: Allclass.map((e) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (wantSkillFilter.contains(e)) {
                          wantSkillFilter.removeAt(wantSkillFilter.indexOf(e));
                          log("have: $e remove from list");
                        } else {
                          wantSkillFilter.add(e);
                          log("add: $e to list");
                        }
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      color: wantSkillFilter.contains(e)
                          ? Colors.blue
                          : Colors.red,
                      child: Center(child: Text("$e")),
                    ),
                  ),
                );
              }).toList()),
              ElevatedButton(
                onPressed: () {
                  log("Drawer Close");
                  _key.currentState!.closeEndDrawer();
                },
                child: const Text("確認"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: _key,
      endDrawer: drawerPage(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  log("filter");
                  _key.currentState!.openEndDrawer();
                },
                icon: const Icon(Icons.calendar_view_day_sharp),
              ),
            ),
          ),
          StreamBuilder(
              stream: dbService.getData(),
              builder: (context, snapshots) {
                log("${snapshots.connectionState}");
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Text("Loading...");
                } else {
                  if (snapshots.hasData) {
                    List<dynamic> filteredData = [];

                    snapshots.data!.forEach((e) {
                      List<dynamic> wantSkillList = e["wantSkill"];
                      wantSkillList.forEach((ele) {
                        if (wantSkillFilter.contains(ele) &&
                            !filteredData.contains(e)) {
                          filteredData.add(e);
                        }
                      });
                    });

                    return Expanded(
                      child: ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            dynamic data = filteredData[index];
                            List<dynamic> mainSkill =
                                data["mainSkill"].toList();
                            List<dynamic> wantSkill =
                                data["wantSkill"].toList();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.black38,
                                      child: const Center(
                                        child: Icon(
                                          Icons.abc,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    color: Colors.black26,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("名前 : ${data['email']}"),
                                        Text("Id : ${data['docId']}"),
                                        const Text("持ちスキル: "),
                                        Row(
                                          children: mainSkill.map((e) {
                                            if (mainSkill.length - 1 !=
                                                mainSkill.indexOf(e)) {
                                              return Text("$e、");
                                            } else {
                                              return Text("$e");
                                            }
                                          }).toList(),
                                        ),
                                        const Text("勉強したいスキル:"),
                                        Row(
                                          children: wantSkill.map((e) {
                                            if (wantSkill.length - 1 !=
                                                wantSkill.indexOf(e)) {
                                              return Text("$e、");
                                            } else {
                                              return Text("$e");
                                            }
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
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
      )),
    );
  }
}
