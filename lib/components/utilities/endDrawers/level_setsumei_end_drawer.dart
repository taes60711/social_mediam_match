import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/app_common_tools.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class LevelsetsumeiEndDrawer extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      child: Column(
        children: [
          BaseTopBar(
            backFunc: () => closePage(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenSize.fitPxWidth(20),
                ),
                child: AppCommonTools().levelsetsumeiBuild(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
