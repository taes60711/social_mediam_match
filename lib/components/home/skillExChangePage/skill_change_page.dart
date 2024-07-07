import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import 'package:social_mediam_match/provider/home/skill_change_view_provider.dart';
import 'package:social_mediam_match/services/user_service.dart';
import '../../../provider/home/skill_change_view_model.dart';
import '../../account/skill_bar.dart';
import '../../utilities/endDrawers/skill_change_filter_end_drawer.dart';
import '../../utilities/endDrawers/skill_setting_end_drawer.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../strings/account/sign_up_strings.dart';
import '../../strings/skillExChangePage/skill_change_page_string.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';

import '../../utilities/loading.dart';
import '../../utilities/stateful_wrapper.dart';

import '../../utilities/style/style_config.dart';

class SkillChangePage extends StatelessWidget {
  const SkillChangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () async {
        await SkillChangeViewModel(context: context).init();
      },
      child: Stack(
        children: [
          _mainBody(context),
          userDetailEndDrawer(),
          skillChangeEndDrawer(),
        ],
      ),
    );
  }
}

Widget _mainBody(BuildContext context) {
  return Column(
    children: [
      BaseTopBar(
        leftWidget: Container(),
        rightWidget: GestureDetector(
          onTap: () {
            openSkillChangeEndDrawer(context: context);
          },
          child: const Icon(Icons.dehaze_rounded),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Builder(
            builder: (context) {
              LoginUser userData = context.watch<UserProvider>().userData;
              List<String> filteredSkill = context.select((SkillChangeProvider value) => value.filteredSkill);

              return APIListView<LoginUser>(
                apiFunc: (page, size) {
                  return UserService().getAllUserData(page, size, userUid: userData.uid, filterSkill: filteredSkill);
                },
                providerList: context.watch<BaseAPIListProvider<LoginUser>>().listData,
                itemChild: (data, index) {
                  return GestureDetector(
                    onTap: () {
                      openUserDetailEndDrawer(context: context, otherUserData: data[index]);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SquareUserIcon(
                            width: 65,
                            height: 100,
                            img: data[index].image,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //名前
                                Text(
                                  data[index].name != "" ? data[index].name ?? "" : data[index].email,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                //職業
                                Text(
                                  data[index].job ?? SkillChangePageString.skExChpagenojobData,
                                  style: TextStyle(
                                    color: hintTextColor,
                                    fontSize: 13,
                                  ),
                                ),
                                //持っているスキル
                                Text(
                                  StepThirdPage.haveSkillText,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                skillBar(
                                  SkillEndDrawerType.haveSkill,
                                  userData: data[index],
                                  fontSize: 12,
                                ),
                                Text(
                                  StepThirdPage.wantSkillText,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                skillBar(
                                  SkillEndDrawerType.wantSkill,
                                  userData: data[index],
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ),
                          //最後ログイン期日
                          Text(
                            "${data[index].lastLogin}${SkillChangePageString.skExChpagebeforDays}",
                            style: TextStyle(color: hintTextColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loadingBuilder: () {
                  return const SkillChangeLoading();
                },
              );
            },
          ),
        ),
      )
    ],
  );
}
