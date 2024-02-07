import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/service/db_service.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    DBService dbService = DBService();

    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                log("filter");
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
                  log("${snapshots.data}");
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshots.data!.length,
                        itemBuilder: (context, index) {
                          dynamic data = snapshots.data![index];
                          List<dynamic> mainSkill = data["mainSkill"].toList();
                          List<dynamic> wantSkill = data["wantSkill"].toList();
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, left: 8, right: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
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
                        }),
                  );
                } else {
                  return const Text("No Data");
                }
              }
            }),
      ],
    ));
  }
}
