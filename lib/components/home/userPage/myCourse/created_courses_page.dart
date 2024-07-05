import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/course_model.dart';
import '../../../../models/user_model.dart';
import '../../../../provider/account/user_provider.dart';
import '../../../../services/course_service.dart';
import '../../../utilities/apiListView/api_list_view.dart';
import '../../../utilities/apiListView/base_api_list_provider.dart';

class CreatedCoursesPage extends StatelessWidget {
  const CreatedCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginUser userData = context.watch<UserProvider>().userData;
    return APIListView<CourseModel>(
      providerList: context.watch<BaseAPIListProvider<CourseModel>>().listData,
      apiFunc: (page, size) {
        return CourseService().getCreatedCourses(page, size, userData.uid);
      },
      itemChild: ((data, index) {
        return Column(
          children: [
            Text("Couser ID: ${data[index].id}"),
            Text(data[index].title),
          ],
        );
      }),
      loadingBuilder: () {
        return Container();
      },
    );
  }
}
