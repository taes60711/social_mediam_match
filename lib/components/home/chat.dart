import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/service/db_service.dart';
import 'package:social_mediam_match/utilities/screen_size.dart';

class Chat extends StatelessWidget {
  Chat({super.key});

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    DBService dbService = DBService();
    List<String> wantSkillFilter = ["english"];

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
              Container(
                width: 100,
                height: 100,
                color: Colors.black38,
              ),
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
                    // log("${snapshots.data}");

                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshots.data!.length,
                          itemBuilder: (context, index) {
                            dynamic data = snapshots.data![index];
                            List<dynamic> mainSkill =
                                data["mainSkill"].toList();
                            List<dynamic> wantSkill =
                                data["wantSkill"].toList();

                            return Column(
                                children: wantSkill.map((e) {
                              if (wantSkillFilter.contains(e)) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, left: 8, right: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.black12,
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
                                          color: Colors.black38,
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
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }).toList());
                            // return Padding(
                            //   padding: const EdgeInsets.only(
                            //       bottom: 8, left: 8, right: 8),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.only(right: 8),
                            //         child: Container(
                            //           width: 80,
                            //           height: 80,
                            //           color: Colors.black12,
                            //           child: const Center(
                            //             child: Icon(
                            //               Icons.abc,
                            //               size: 50,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       Expanded(
                            //         child: Container(
                            //           color: Colors.black38,
                            //           child: Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text("名前 : ${data['email']}"),
                            //               Text("Id : ${data['docId']}"),
                            //               const Text("持ちスキル: "),
                            //               Row(
                            //                 children: mainSkill.map((e) {
                            //                   if (mainSkill.length - 1 !=
                            //                       mainSkill.indexOf(e)) {
                            //                     return Text("$e、");
                            //                   } else {
                            //                     return Text("$e");
                            //                   }
                            //                 }).toList(),
                            //               ),
                            //               const Text("勉強したいスキル:"),
                            //               Row(
                            //                 children: wantSkill.map((e) {
                            //                   if (wantSkill.length - 1 !=
                            //                       wantSkill.indexOf(e)) {
                            //                     return Text("$e、");
                            //                   } else {
                            //                     return Text("$e");
                            //                   }
                            //                 }).toList(),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // );
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
