import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../global/global_view_model.dart';

import '../../../services/post_service.dart';
import '../../utilities/background_widget.dart';

import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

import 'post_page_by_viewer.dart';

class PostMainPage extends ConsumerStatefulWidget {
  const PostMainPage({super.key});

  @override
  ConsumerState<PostMainPage> createState() => _PostMainPageState();
}

PageController pageController = PageController();
int pageIndex = 0;

class _PostMainPageState extends ConsumerState<PostMainPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> postsWidget = [
      PostByView(),
      PostByView(),
      CommonScaffold(
        child: Center(
            child: Container(
          width: 50,
          height: 50,
          color: const Color.fromARGB(255, 136, 139, 141),
        )),
      ),
    ];
    return CommonScaffold(
      child: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: postsWidget,
            onPageChanged: (value) {
              pageIndex = value;
              setState(() {});
            },
          ),
          AnimatedPositioned(
            top: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? 3 : -45,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 150),
            child: Column(
              children: [
                _buildSearchBar(ref, () => setState(() {}), context),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          0,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        width: ScreenSize.width / 3,
                        height: 40,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "人氣",
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                            Visibility(
                              visible: pageIndex == 0,
                              child: Container(
                                width: 15,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          1,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        width: ScreenSize.width / 3,
                        height: 40,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "最新",
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                            Visibility(
                              visible: pageIndex == 1,
                              child: Container(
                                width: 15,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          2,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      },
                      child: Container(
                        width: ScreenSize.width / 3,
                        height: 40,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "看板",
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                            Visibility(
                              visible: pageIndex == 2,
                              child: Container(
                                width: 15,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
  return GestureDetector(
    onTap: () async {
      await ref.read(listControllerProvider.notifier).replaceApi((page, size) {
        return PostService().getPostByTextFilter(page, size, "打");
      });
      render();
      // BaseEndDrawer().show(context);
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.greyColor57,
        borderRadius: BorderRadius.circular(5),
      ),
      width: ScreenSize.width,
      height: 36,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.search, color: AppColors.whiteColor),
          ),
          Text(
            "搜尋",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}
