// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/provider/corse_view_model.dart';

import '../../../../models/course_model.dart';
import '../../../../provider/course_provider.dart';
import '../../../../services/course_service.dart';
import '../../../utilities/apiListView/api_list_view.dart';
import '../../../utilities/apiListView/base_api_list_provider.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';

class CourseMemberManager extends StatelessWidget {
  const CourseMemberManager({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: APIListView<AddedCourseMemberModel>(
          providerList: context.watch<BaseAPIListProvider<AddedCourseMemberModel>>().listData,
          apiFunc: (page, size) {
            return CourseService().getCourseAddedMember(page, size, context.read<CourseProvider>().choicedCourseId);
          },
          itemChild: ((data, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data[index].status == 0 ? "未加入" : "已加入"),
                  Container(margin: const EdgeInsets.all(5), width: ScreenSize.width, height: 0.3, color: hintTextColor),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: UserIcon(iconSize: 35, image: data[index].userData.image),
                            ),
                            Text(
                                "${data[index].userData.name == "" || data[index].userData.name == null ? data[index].userData.email : data[index].userData.name}"),
                          ],
                        ),
                      ),
                      Container(margin: const EdgeInsets.all(5), width: 0.5, height: 30, color: hintTextColor),
                      Visibility(
                        visible: data[index].status == 0,
                        child: GestureDetector(
                          onTap: () {
                            CourseViewModel(courseContext: context).updateCourseMemberStatus(updateData: data[index]);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: normalBgColor2,
                            ),
                            child: const Icon(
                              FontAwesomeIcons.circle,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          CourseViewModel(courseContext: context).deleteCourseMember(deletedMember: data[index]);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: normalBgColor2,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.close,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          loadingBuilder: () {
            return Container();
          },
        ),
      ),
    );
  }
}
