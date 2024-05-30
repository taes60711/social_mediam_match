import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';

import '../../../../models/course_model.dart';
import '../../../../states/course_state.dart';

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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("exit"),
              ),
              const Text("申請中的使用者"),
              Expanded(
                  child: Column(
                children: addedCourseMembers
                    .map(
                      (e) => Container(
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
                                    courseState.deleteUserFromCourse(courseId: courseId, userUId: e.memberUid);
                                  },
                                  child: Text("NO"),
                                ),
                              ],
                            ),
                            Text(e.memberUid),
                            Text("${e.status}"),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
