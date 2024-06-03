import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';

import '../../../../models/course_model.dart';
import '../../../../states/course_state.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';

class CourseMemberManager extends StatelessWidget {
  final int courseId;
  const CourseMemberManager({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    CourseState courseState = context.read<CourseState>();
    List<AddedCourseMemberModel> addedCourseMembers = context.watch<CourseState>().addedCourseMembers;
    return StatefulWrapper(
      onInit: () {
        courseState.getAddedCourseMember(courseId: courseId, isFirst: true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: ScreenSize().width * 0.33,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  SizedBox(width: ScreenSize().width * 0.33, child: const Center(child: Text("成員管理"))),
                ],
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: TabBar(
                      tabs: const [
                        SizedBox(
                          height: 25,
                          child: Tab(text: '已加入'),
                        ),
                        SizedBox(
                          height: 25,
                          child: Tab(text: '審核中'),
                        ),
                      ],
                      isScrollable: true,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 1.0, color: normalBgColor),
                        insets: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      labelPadding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                      labelColor: normalBgColor2,
                    ),
                    body: TabBarView(children: [
                      Column(
                        children: addedCourseMembers
                            .map(
                              (e) => e.status == 1
                                  ? Container(
                                      margin: EdgeInsets.all(5),
                                      color: Colors.deepOrange,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              UserIcon(
                                                iconSize: 30,
                                                image: e.userData.image,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  "${e.userData.name != "" ? e.userData.name ?? "" : e.userData.email}",
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Future<void> deleteMemberCheck() {
                                                    return showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: const Text('確認'),
                                                          content: const Text('確定要移除該使用者?'),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              child: const Text('確定'),
                                                              onPressed: () {
                                                                courseState.deleteUserFromCourse(
                                                                    courseId: courseId, userUId: e.memberUid);
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            ElevatedButton(
                                                              child: const Text('取消'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }

                                                  deleteMemberCheck();
                                                },
                                                child: Text("Delete"),
                                              ),
                                            ],
                                          ),
                                          Text(e.memberUid),
                                          Text("${e.status}"),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            )
                            .toList(),
                      ),
                      Column(
                        children: addedCourseMembers
                            .map(
                              (e) => e.status == 0
                                  ? Container(
                                      margin: EdgeInsets.all(5),
                                      color: Colors.deepOrange,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              UserIcon(
                                                iconSize: 30,
                                                image: e.userData.image,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  "${e.userData.name != "" ? e.userData.name ?? "" : e.userData.email}",
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  courseState.updateAddedUserStatus(addedCourseMembers,
                                                      courseId: courseId, userUId: e.memberUid);
                                                },
                                                child: Text("OK"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Future<void> deleteMemberCheck() {
                                                    return showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: const Text('確認'),
                                                          content: const Text('確定要移除該使用者?'),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              child: const Text('確定'),
                                                              onPressed: () {
                                                                courseState.deleteUserFromCourse(
                                                                    courseId: courseId, userUId: e.memberUid);
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            ElevatedButton(
                                                              child: const Text('取消'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }

                                                  deleteMemberCheck();
                                                },
                                                child: Text("NO"),
                                              ),
                                            ],
                                          ),
                                          Text(e.memberUid),
                                          Text("${e.status}"),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            )
                            .toList(),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
