import 'dart:developer';
import 'package:flutter/material.dart';
import '../../states/services/db_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DBService dbService = DBService();

    return SafeArea(
      child: StreamBuilder(
          stream: dbService.getPostData(),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("文章內容："),
                                      Text("${data["content"]}"),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("留言:"),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: commentdata.map((r) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Level : ${commentdata.indexOf(r)}"),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          color: Colors.deepPurpleAccent,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text("使用者：${r["user"]}"),
                                                      ],
                                                    ),
                                                    Text("內容：${r["content"]}")
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
                    });
              } else {
                return const Text("No Data");
              }
            }
          }),
    );
  }
}
