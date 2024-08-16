// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/utilities/apiListView/base_api_list_provider.dart';
import '../../components/utilities/endDrawers/skill_change_filter_end_drawer.dart';
import '../../models/skill_model.dart';
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

    List<RequestSkillListData> skillList = context.read<SkillChangeProvider>().skillList;
    List<String> filteredSkillList = context.read<SkillChangeProvider>().filteredSkill;

    List<String> filteredSkillIdsList = filteredSkillList.map((e) {
      return (skillList.firstWhere((element) => element.name == e).id).toString();
    }).toList();

    int loadSize = context.read<BaseAPIListProvider<LoginUser>>().size;
    await context.read<BaseAPIListProvider<LoginUser>>().reloadData(
          apiFunc: () async => await UserService().getAllUserData(
            0,
            loadSize,
            userUid: userData.uid,
            filterSkill: filteredSkillIdsList,
          ),
        );
    int preLoadPage = context.read<BaseAPIListProvider<LoginUser>>().page;
    await context.read<BaseAPIListProvider<LoginUser>>().preLoad(
          apiFunc: () async => await UserService().getAllUserData(
            preLoadPage,
            loadSize,
            userUid: userData.uid,
            filterSkill: filteredSkillIdsList,
          ),
        );

    closeSkillChangeEndDrawer(context: context);
  }
}
