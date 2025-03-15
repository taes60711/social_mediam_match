import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/userPage/myCourse/liked_courses_page.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';

import '../../../utilities/appBar/basic_top_bar.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/app_colors.dart';
import 'added_courses_page.dart';
import 'created_courses_page.dart';

class MyCoursePage extends BaseEndDrawer {
  int pageIndex = 0;
  PageController pageController = PageController();
  List<Widget> coursePage = [
    const AddedCoursePage(),
    const CreatedCoursePage(),
    const LikedCoursesPage(),
  ];

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          title: "技術分享",
          backFunc: () {
            closePage();
          },
        ),
        Container(
          margin: EdgeInsets.only(
            left: ScreenSize.fitPxHeight(30),
            right: ScreenSize.fitPxHeight(30),
            bottom: ScreenSize.fitPxHeight(5),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.greyColor98,
          ),
          child: Row(
            children: [
              Expanded(child: _buildTabBtn(context, tabText: "已加入", index: 0)),
              Expanded(child: _buildTabBtn(context, tabText: "我的", index: 1)),
              Expanded(child: _buildTabBtn(context, tabText: "已收藏", index: 2)),
            ],
          ),
        ),
        SizedBox(height: ScreenSize.fitPxHeight(5)),
        Expanded(
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
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
        if ((pageController.page! - index).abs() > 1) {
          pageController.jumpToPage(
            index,
          );
        } else {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
          );
        }
      },
      child: Container(
        height: ScreenSize.fitPxHeight(30),
        alignment: Alignment.center,
        decoration: pageIndex == index
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.orangeColor,
              )
            : BoxDecoration(color: AppColors.transparent),
        child: Text(
          tabText,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: ScreenSize.fontSize12,
          ),
        ),
      ),
    );
  }
}
