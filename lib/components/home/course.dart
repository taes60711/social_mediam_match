import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:social_mediam_match/service/db_service.dart';

class Course extends StatelessWidget {
  const Course({super.key});

  @override
  Widget build(BuildContext context) {
    DBService dbService = DBService();

    return SafeArea(
      child: StreamBuilder(
          stream: dbService.getCourseData(),
          builder: (context, snapshots) {
            log("${snapshots.connectionState}");
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            } else {
              if (snapshots.hasData) {
                log("${snapshots.data}");
                return ListView.builder(
                    itemCount: snapshots.data!.length,
                    itemBuilder: (context, index) {
                      dynamic data = snapshots.data![index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Color.fromARGB(255, 171, 151, 225),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    Text("發文者:"),
                                    Text(data["mainuser"]),
                                  ],
                                ),
                                Text("課程名稱： ${data["classname"]}"),
                                Text("課程内容："),
                                Text("${data["content"]}"),
                                Text("發文時間： ${data["timestamp"]}"),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      log("goto Detail");
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 30,
                                      color: Colors.red,
                                      child: const Center(
                                        child: Text("課程詳細"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const Text("No Data");
              }
            }
          }),
    );
  }
}
