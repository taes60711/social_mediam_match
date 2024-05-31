import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';

import '../../../../models/course_model.dart';
import '../../../../models/user_model.dart';
import '../../../../states/course_state.dart';

class AddedCoursesPage extends StatelessWidget {
  final LoginUser userData;
  const AddedCoursesPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    CourseState courseState = context.read<CourseState>();
    List<CourseModel> myAddedCourseData = context.watch<CourseState>().myAddedCourseData;

    Widget component = Container();
    if (myAddedCourseData.isNotEmpty) {
      component = Container(
        child: Column(
          children: myAddedCourseData.map((e) {
            return Text(e.title);
          }).toList(),
        ),
      );
    }

    return StatefulWrapper(
      onInit: () {
        courseState.getAddedCourses(userId: userData.uid, searchType: "First");
      },
      child: Scaffold(
        body: SafeArea(child: component),
      ),
    );
  }
}
