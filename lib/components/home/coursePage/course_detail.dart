import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import '../../../models/course_model.dart';

class CourseDetail extends StatelessWidget {
  final CourseModel? courseData;
  const CourseDetail({super.key, this.courseData});

  @override
  Widget build(BuildContext context) {
    Widget component = Container();

    if (courseData != null) {
      CourseModel realCourseData = courseData!;
      component = Container(
        width: ScreenSize().width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("課程標題:${realCourseData.title}"),
            Text("課程創建者${realCourseData.courseCreateduserInfo.email}"),
            Text("課程內容:${realCourseData.content}"),
          ],
        ),
      );
    }
    return component;
  }
}
