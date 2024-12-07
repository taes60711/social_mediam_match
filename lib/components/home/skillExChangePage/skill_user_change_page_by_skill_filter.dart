import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';

import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';

import '../../../models/user_model.dart';

import '../../../provider/account/user_provider.dart';
import '../../../services/user_service.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/loading.dart';
import 'skill_utilites.dart';

final userExChangeSkillFilterlistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

class SkillUserChangeBySkillFilter extends BaseEndDrawer {
  final List<String> filterSkill;
  SkillUserChangeBySkillFilter({required this.filterSkill});
  @override
  Widget build(WidgetRef ref) {
    ProfileData userData = ref.watch(loginUserData);
    return Column(
      children: [
        const BaseTopBar(),
        Expanded(
          child: APIListWidget<ProfileData>(
            size: 6,
            apiFunc: (page, size) {
              return UserService().getAllUserData(page, size, userUid: userData.uid, filterSkill: filterSkill);
            },
            needReloadCheck: true,
            listControllerProvider: userExChangeSkillFilterlistControllerProvider,
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
