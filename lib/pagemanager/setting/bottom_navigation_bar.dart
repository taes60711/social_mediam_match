import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/utilities/main_button.dart';
import '../../components/utilities/style/screen_size.dart';
import '../../components/utilities/style/style_config.dart';
import '../../global/home_global_view_model.dart';
import '../../pageManager/enum/bottom_bar_path.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  List<BottomBarPath> mainPagePath = [
    BottomBarPath.home,
    BottomBarPath.skillExChange,
    BottomBarPath.course,
    BottomBarPath.chatRoom,
    BottomBarPath.my,
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: ScreenSize.width,
        height: ScreenSize.fitPxHeight(60),
        child: Center(
          child: Container(
            width: ScreenSize.width,
            height: ScreenSize.fitPxHeight(60),
            margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
            decoration: BoxDecoration(
              color: AppColors.greyColor54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: mainPagePath.map((e) {
                int pageIndex = e.path;
                double rightPadding = 0;
                double leftPadding = 0;

                if (e == BottomBarPath.home) {
                  rightPadding = 3;
                  leftPadding = ScreenSize.fitPxHeight(2.5);
                } else if (e == BottomBarPath.chatRoom) {
                  rightPadding = 5;
                  leftPadding = ScreenSize.fitPxHeight(3);
                }

                return MainBtn(
                  onPress: () {
                    HomeGlobalViewModel().changeMainPage(e);
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: (ScreenSize.width - ScreenSize.fitPxHeight(40)) / 5,
                    child: Center(
                      child: ref.watch(bottomNavigationBarProvider) == pageIndex
                          ?
                          //　選択してる
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  e.icon,
                                  color: AppColors.whiteColor,
                                  size: ScreenSize.fitPxHeight(23),
                                ),
                                SizedBox(
                                  height: ScreenSize.fitPxHeight(4),
                                ),
                                Container(
                                  width: 10,
                                  margin: EdgeInsets.only(left: leftPadding),
                                  height: 2,
                                  color: AppColors.whiteColor,
                                ),
                              ],
                            )
                          :
                          //　選択してない
                          Padding(
                              padding: EdgeInsets.only(right: rightPadding),
                              child: Icon(
                                e.icon,
                                color: AppColors.greyColor130,
                                size: ScreenSize.fitPxHeight(23),
                              ),
                            ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
