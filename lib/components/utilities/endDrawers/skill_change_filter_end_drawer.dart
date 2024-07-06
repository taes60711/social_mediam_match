import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/provider/home/skill_change_view_provider.dart';
import '../../home/skillExChangePage/skill_change_filter_page.dart';

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

///MARK: void スキル交換ページ閉じるように
void closeSkillChangeEndDrawer({required BuildContext context}) {
  context.read<SkillChangeProvider>().changeEndDrawerStatus(SkillChangeEndDrawerType.close);
}

///MARK: widget スキル交換ページ用EndDrawer
Widget skillChangeEndDrawer() {
  return Builder(builder: (context) {
    print("skillChangeEndDrawer");
    SkillChangeEndDrawerType postCommentEndDrawer = context.select((SkillChangeProvider value) => value.endDrawerOpenInfo);

    Widget endDrawerWidget = Container();

    if (postCommentEndDrawer == SkillChangeEndDrawerType.open) {
      endDrawerWidget = EndDrawer(
        title: tr("skillFilterTitle"),
        onDismissed: () {
          closeSkillChangeEndDrawer(context: context);
        },

        ///文章詳細ページ
        child: const SkillChangeFilterPage(),
      );
    }
    return endDrawerWidget;
  });
}
