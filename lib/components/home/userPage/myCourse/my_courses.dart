import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utilities/FadeScalePage/base_fade_scale_page.dart';
import '../../../utilities/basic_top_bar.dart';
import '../../../utilities/custom_button.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';
import 'added_courses_page.dart';
import 'created_courses_page.dart';

class MyCoursePage extends BaseFadeScalePage {
  int pageIndex = 0;
  PageController pageController = PageController();
  List<Widget> coursePage = [
    const AddedCoursePage(),
    const CreatedCoursePage(),
  ];

  @override
  bool needWaitOpenPage() {
    return true;
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          title: "技術分享",
          leftWidget: Container(),
          rightWidget: MainBtn(
            onPress: () {
              closePage();
            },
            child: Icon(
              Icons.close,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        Row(
          children: [
            _buildTabBtn(context, tabText: "已加入", index: 0),
            _buildTabBtn(context, tabText: "我的", index: 1),
          ],
        ),
        SizedBox(height: ScreenSize.fitPxHeight(5)),
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (value) {
              pageIndex = value;
              render();
            },
            children: coursePage,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBtn(BuildContext context, {required String tabText, required int index}) {
    return GestureDetector(
      onTap: () async {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        );
      },
      child: Container(
        width: ScreenSize.width / 2,
        height: ScreenSize.fitPxHeight(30),
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tabText,
              style: TextStyle(color: AppColors.whiteColor),
            ),
            Visibility(
              visible: pageIndex == index,
              child: Container(
                width: 15,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
