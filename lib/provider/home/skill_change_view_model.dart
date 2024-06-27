import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/utilities/apiListView/base_api_list_provider.dart';
import '../../components/utilities/endDrawers/skill_change_filter_end_drawer.dart';
import '../../models/user_model.dart';
import '../../services/skill_service.dart';
import '../../services/user_service.dart';
import '../account/user_provider.dart';
import 'skill_change_view_provider.dart';

class SkillChangeViewModel {
  BuildContext context;
  SkillChangeViewModel({required this.context});
  Future<void> init() async {
    await SkillService().requestSkillList().then((requestSkillListData) {
      context.read<SkillChangeProvider>().getFilterList(requestSkillListData);
    });
  }

  Future<void> filterSearchStart() async {
    LoginUser userData = context.read<UserProvider>().userData;
    List<String> filteredSkills = context.read<SkillChangeProvider>().filteredSkill;
    await context.read<BaseAPIListProvider<LoginUser>>().reloadData(
          apiFunc: () async => await UserService().getAllUserData(0, 5, userUid: userData.uid, filterSkill: filteredSkills),
        );
    int preLoadPage = context.read<BaseAPIListProvider<LoginUser>>().page;
    await context.read<BaseAPIListProvider<LoginUser>>().preLoad(
          apiFunc: () async =>
              await UserService().getAllUserData(preLoadPage, 5, userUid: userData.uid, filterSkill: filteredSkills),
        );
    // ignore: use_build_context_synchronously
    closeSkillChangeEndDrawer(context: context);
  }
}
