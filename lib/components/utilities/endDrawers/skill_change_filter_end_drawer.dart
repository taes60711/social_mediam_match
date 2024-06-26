import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/home/skill_change_provider.dart';

import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../services/user_service.dart';
import '../apiListView/base_api_list_provider.dart';
import 'custom_end_drawer.dart';

enum SkillChangeEndDrawerType {
  open,
  close;
}

///Before use need ParentWidget Create SkillChangeProvider

///MARK: void スキル交換ページ開くように
void openSkillChangeEndDrawer({required BuildContext context}) {
  context.read<SkillChangeProvider>().changeEndDrawerStatus(SkillChangeEndDrawerType.open);
}

///MARK: widget スキル交換ページ用EndDrawer
Widget skillChangeEndDrawer() {
  return Builder(builder: (context) {
    print("skillChangeEndDrawer");
    SkillChangeEndDrawerType postCommentEndDrawer = context.select((SkillChangeProvider value) => value.endDrawerOpenInfo);

    SkillChangeProvider skillChangeProvider = context.read<SkillChangeProvider>();

    Widget endDrawerWidget = Container();

    if (postCommentEndDrawer == SkillChangeEndDrawerType.open) {
      endDrawerWidget = EndDrawer(
        title: "",
        onDismissed: () {
          skillChangeProvider.changeEndDrawerStatus(SkillChangeEndDrawerType.close);
        },

        ///文章詳細ページ
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                LoginUser userData = context.read<UserProvider>().userData;
                context.read<SkillChangeProvider>().onChangeSkillFilter(['japanese']);
                List<LoginUser> s = await UserService()
                    .getAllUserData(0, 5, userUid: userData.uid, filterSkill: context.read<SkillChangeProvider>().filterSkill);
                context.read<BaseAPIListProvider<LoginUser>>().reloadData(reloadData: s);
              },
              child: Text("111"),
            ),
          ],
        ),
      );
    }
    return endDrawerWidget;
  });
}
