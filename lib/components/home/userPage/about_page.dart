import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/app_common_tools.dart';

import 'package:social_mediam_match/components/utilities/custom_expansion_title.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';

import '../../utilities/appBar/basic_top_bar.dart';

class AboutPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          title: "程度劃分",
          backFunc: () {
            closePage();
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.fitPxWidth(16),
                  ),
                  child: CustomExpansionTile(
                    initiallyExpanded: true,
                    isNeedLoadingWidget: false,
                    title: Text(
                      "程度分級",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize16,
                      ),
                    ),
                    collapsedTrailingWidget: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.whiteColor,
                      size: ScreenSize.fontSize22,
                    ),
                    expandedTrailingWidget: Icon(
                      Icons.keyboard_arrow_up,
                      color: AppColors.whiteColor,
                      size: ScreenSize.fontSize22,
                    ),
                    children: [
                      AppCommonTools().levelsetsumeiBuild(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
