import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/provider/corses_view_model.dart';
import 'package:social_mediam_match/provider/course_state.dart';

import '../../../../models/course_model.dart';
import '../../../../services/course_service.dart';
import '../../../utilities/apiListView/api_list_view.dart';
import '../../../utilities/apiListView/base_api_list_provider.dart';

class CourseMemberManager extends StatelessWidget {
  const CourseMemberManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: APIListView<AddedCourseMemberModel>(
        providerList: context.watch<BaseAPIListProvider<AddedCourseMemberModel>>().listData,
        apiFunc: (page, size) {
          return CourseService().getCourseAddedMember(page, size, context.read<CourseState>().choicedCourseId);
        },
        itemChild: ((data, index) {
          return data[index].status == 0
              ? Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          UserIcon(iconSize: 35, image: data[index].userData.image),
                          Text("${data[index].status}"),
                          Text("未加入"),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        CoursesViewModel(courseContext: context).updateCourseMemberStatus(updateData: data[index]);
                      },
                      child: Text("O"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        CoursesViewModel(courseContext: context).deleteCourseMember(deletedMember: data[index]);
                      },
                      child: Text("X"),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        UserIcon(iconSize: 35, image: data[index].userData.image),
                        Text("${data[index].status}"),
                        Text("已加入"),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        CoursesViewModel(courseContext: context).deleteCourseMember(deletedMember: data[index]);
                      },
                      child: Text("X"),
                    ),
                  ],
                );
        }),
        loadingBuilder: () {
          return Container();
        },
      ),
    );
  }
}
