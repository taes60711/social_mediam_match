import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';

import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';

import '../../../models/user_model.dart';

import '../../../services/user_service.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/loading.dart';
import 'skill_utilites.dart';

final userExChangeTextFilteredlistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

class SkillUserChangeByTextFilter extends BaseEndDrawer {
  final String searchText;
  SkillUserChangeByTextFilter({required this.searchText});
  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        const BaseTopBar(),
        Expanded(
          child: APIListWidget<ProfileData>(
            size: 6,
            apiFunc: (page, size) {
              return UserService().requestUserDataByNamePart(page, size, userName: searchText);
            },
            needReloadCheck: true,
            listControllerProvider: userExChangeTextFilteredlistControllerProvider,
            loadingWidget: const SkillChangeLoading(),
            noDataWidget: SkillUtilites().noDataBuilder(),
            itemChild: (data, index) {
              return SkillUtilites().skillUserChangeContent(context, data: data);
            },
          ),
        )
      ],
    );
  }
}
