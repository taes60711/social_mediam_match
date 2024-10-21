import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/utilities/style/screen_size.dart';
import '../../components/utilities/style/style_config.dart';
import '../../global/global_view_model.dart';
import '../enum/bottom_bar_path.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.width,
      height: ScreenSize.fitPxHeight(60),
      child: Center(
        child: Container(
          width: ScreenSize.width,
          height: ScreenSize.fitPxHeight(60),
          margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
          decoration: BoxDecoration(
            color: AppColors.greyColor54,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: BottomBarPath.values.map((e) {
              int pageIndex = e.path;
              double rightPadding = 0;

              if (e == BottomBarPath.home) {
                rightPadding = 3;
              } else if (e == BottomBarPath.chatRoom) {
                rightPadding = 5;
              }

              return GestureDetector(
                onTap: () {
                  GlobalViewModel().changeMainPage(pageIndex);
                },
                child: Container(
                  color: Colors.transparent,
                  width: (ScreenSize.width - ScreenSize.fitPxHeight(40)) / 5,
                  child: Center(
                    child: ref.watch(bottomNavigationBarProvider) == pageIndex
                        ?
                        //　選択してる
                        Container(
                            decoration: BoxDecoration(
                              color: AppColors.greyColor98,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenSize.fitPxHeight(10),
                              vertical: ScreenSize.fitPxHeight(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: rightPadding),
                              child: Icon(
                                e.icon,
                                color: AppColors.whiteColor,
                                size: ScreenSize.fitPxHeight(23),
                              ),
                            ),
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
    );
  }
}
