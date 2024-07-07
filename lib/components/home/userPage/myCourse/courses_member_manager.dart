import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/provider/corse_view_model.dart';

import '../../../../models/course_model.dart';
import '../../../../provider/course_provider.dart';
import '../../../../services/course_service.dart';
import '../../../utilities/apiListView/api_list_view.dart';
import '../../../utilities/apiListView/base_api_list_provider.dart';

class CourseMemberManager extends StatelessWidget {
  const CourseMemberManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: APIListView<AddedCourseMemberModel>(
        providerList: context.watch<BaseAPIListProvider<AddedCourseMemberModel>>().listData,
        apiFunc: (page, size) {
          return CourseService().getCourseAddedMember(page, size, context.read<CourseProvider>().choicedCourseId);
        },
        itemChild: ((data, index) {
          return Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    UserIcon(iconSize: 35, image: data[index].userData.image),
                    Text(
                        "${data[index].userData.name == "" || data[index].userData.name == null ? data[index].userData.email : data[index].userData.name}"),
                    Text(data[index].status == 0 ? "未加入" : "已加入"),
                  ],
                ),
              ),
              Visibility(
                visible: data[index].status == 0,
                child: ElevatedButton(
                  onPressed: () {
                    CourseViewModel(courseContext: context).updateCourseMemberStatus(updateData: data[index]);
                  },
                  child: Text("O"),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  CourseViewModel(courseContext: context).deleteCourseMember(deletedMember: data[index]);
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
