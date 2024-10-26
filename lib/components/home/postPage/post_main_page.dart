import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
import '../../../global/global_view_model.dart';
import '../../../models/post_model.dart';
import '../../../services/post_service.dart';
import '../../utilities/BottomSheets/base_bottom_sheet.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_page_by_new.dart';
import 'post_page_by_viewer.dart';

final topPostProvider = StateProvider<List<PostModel>>((ref) {
  return [];
});

final choicedPostProvider = StateProvider<PostModel>((ref) {
  return PostModel();
});

class PostMainPage extends ConsumerStatefulWidget {
  const PostMainPage({super.key});

  @override
  ConsumerState<PostMainPage> createState() => _PostMainPageState();
}

PageController pageController = PageController();
int pageIndex = 0;

class _PostMainPageState extends ConsumerState<PostMainPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    pageIndex = 0;
    List<PostModel> topPosts = await PostService().getPostByType(0, 3, -1);
    ref.read(topPostProvider.notifier).update((state) => topPosts);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> postsWidget = [
      const PostByView(),
      const PostByNew(),
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
            children: postsWidget,
            onPageChanged: (value) {
              pageIndex = value;
              setState(() {});
            },
          ),

          /// 検索バー＆ tabバー
          AnimatedPositioned(
            top: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60)
                ? ScreenSize.fitPxHeight(ref.watch(topPostProvider).isNotEmpty ? 45 : 0)
                : ScreenSize.fitPxHeight(0),
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 200),
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
                        height: ScreenSize.fitPxHeight(30),
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
                        height: ScreenSize.fitPxHeight(30),
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
                        height: ScreenSize.fitPxHeight(30),
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

          /// top　文章
          ref.read(topPostProvider).isEmpty
              ? Container()
              : Container(
                  width: ScreenSize.width,
                  color: AppColors.black37,
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenSize.fitPxHeight(8),
                    horizontal: ScreenSize.fitPxHeight(15),
                  ),
                  child: CarouselSlider(
                    items: ref.read(topPostProvider).map((e) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Hot!",
                            style: TextStyle(color: AppColors.redColor, fontSize: 12),
                          ),
                          SizedBox(width: ScreenSize.fitPxWidth(5)),
                          GestureDetector(
                            onTap: () {
                              BaseBottomSheet().show(
                                context,
                                child: PostViewUtilities().userProfileView(
                                  userData: e.postUserInfo,
                                ),
                              );
                            },
                            child: UserIcon(
                              iconSize: 20,
                              image: e.postUserInfo.image,
                            ),
                          ),
                          SizedBox(width: ScreenSize.fitPxWidth(8)),
                          Text(
                            e.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.whiteColor),
                          ),
                        ],
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: ScreenSize.fitPxHeight(20),
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                    ),
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
    },
    child: Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyColor57,
        borderRadius: BorderRadius.circular(5),
      ),
      width: ScreenSize.width,
      height: ScreenSize.fitPxHeight(35),
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
