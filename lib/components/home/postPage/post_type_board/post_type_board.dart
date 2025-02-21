import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';

import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/provider/post/post_provider.dart';

import '../../../../models/post_model.dart';
import '../../../utilities/common_scaffold.dart';
import '../../../utilities/main_button.dart';
import 'post_page_by_type.dart';

class PostTypeMainPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    List<PostBoard> allBoard = ref.read(allPostBoardListData);

    return CommonScaffold(
      child: Column(
        children: [
          BaseTopBar(
            backFunc: () => closePage(),
            title: "類別",
          ),
          Expanded(
            child: Column(
              children: allBoard
                  .map(
                    (e) => MainBtn(
                      onPress: () {
                        ref.read(choicedPostBoardProvider.notifier).update((state) => e);
                        PostPageByType().show(context);
                      },
                      child: Container(
                        color: AppColors.black37,
                        padding: EdgeInsets.symmetric(vertical: ScreenSize.fitPxHeight(5)),
                        margin: EdgeInsets.only(bottom: ScreenSize.fitPxHeight(13)),
                        width: ScreenSize.width,
                        child: Row(
                          children: [
                            SizedBox(width: ScreenSize.fitPxHeight(20)),
                            SizedBox(
                              width: ScreenSize.fitPxHeight(25),
                              height: ScreenSize.fitPxHeight(25),
                              child: Icon(
                                e.iconData,
                                color: AppColors.whiteColor.withOpacity(0.8),
                                size: ScreenSize.fitPxHeight(20),
                              ),
                            ),
                            SizedBox(width: ScreenSize.fitPxHeight(10)),
                            Text(
                              e.chineseName,
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.8),
                                fontSize: ScreenSize.fontSize16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
