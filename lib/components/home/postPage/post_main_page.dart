import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/home/postPage/post_page_by_textfilter.dart';
import 'package:social_mediam_match/components/home/postPage/post_type_board/post_type_board.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/inputField/base_input.dart';

import '../../../global/home_global_view_model.dart';

import '../../../provider/post/post_provider.dart';

import '../../../provider/post/post_view_model.dart';
import '../../utilities/bottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/common_scaffold.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_detail_page.dart';
import 'post_page_by_new.dart';
import 'post_page_by_viewer.dart';

class PostMainPage extends ConsumerStatefulWidget {
  const PostMainPage({super.key});

  @override
  ConsumerState<PostMainPage> createState() => _PostMainPageState();
}

PageController pageController = PageController();
int pageIndex = 0;

class _PostMainPageState extends ConsumerState<PostMainPage> {
  late PostViewModel viewModel;

  @override
  void initState() {
    pageIndex = 0;
    viewModel = PostViewModel(ref: ref, context: context, render: () => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> postsWidget = [
      const PostByView(),
      const PostByNew(),
      const PostTypeBoard(),
    ];
    return CommonScaffold(
      type: PageType.main,
      child: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: const ClampingScrollPhysics(),
            children: postsWidget,
            onPageChanged: (value) {
              pageIndex = value;
              setState(() {});

              /// BottomNavigiatonbar隠れたら表示される
              if (ref.watch(bottomNavationBarPosProvider) == ScreenSize.fitPxHeight(-60)) {
                Future.delayed(const Duration(milliseconds: 200)).then(
                  (value) => HomeGlobalViewModel().bottomBarHideStateChage(false),
                );
              }
            },
          ),

          /// 検索バー＆ tabバー
          AnimatedPositioned(
            top: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60)
                ? ScreenSize.fitPxHeight(ref.watch(topPostProvider).isNotEmpty ? 45 : 0)
                : ScreenSize.fitPxHeight(0),
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 300),
            child: Column(
              children: [
                _buildSearchBar(ref, () => setState(() {}), context),
                Row(
                  children: [
                    _buildTabBtn(context, tabText: "人氣", index: 0),
                    _buildTabBtn(context, tabText: "最新", index: 1),
                    _buildTabBtn(context, tabText: "看板", index: 2),
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
                      return MainBtn(
                        onPress: () {
                          ref.read(choicedPostProvider.notifier).update((state) => e);
                          PostDetailPage(dataIndex: pageIndex).show(context);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Hot!",
                                style: TextStyle(color: AppColors.redColor, fontSize: ScreenSize.fontSize12),
                              ),
                              SizedBox(width: ScreenSize.fitPxWidth(5)),
                              MainBtn(
                                needOnPressEffect: false,
                                onPress: () {
                                  UserProfileBottomSheet(userData: e.postUserInfo).show(context);
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
                          ),
                        ),
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

Widget _buildTabBtn(BuildContext context, {required String tabText, required int index}) {
  return MainBtn(
    onPress: () async {
      if ((pageIndex - index).abs() == 1) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        );
      } else {
        pageController.jumpToPage(index);
      }
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
            tabText,
            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
          ),
          Visibility(
            visible: pageIndex == index,
            child: Container(
              width: ScreenSize.fitPxWidth(15),
              height: ScreenSize.fitPxWidth(1),
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
  TextEditingController searchController = TextEditingController();

  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: ScreenSize.fitPxWidth(10),
    ),
    decoration: BoxDecoration(
      color: AppColors.greyColor57,
      borderRadius: BorderRadius.circular(5),
    ),
    width: ScreenSize.width,
    height: ScreenSize.fitPxHeight(35),
    child: Row(
      children: [
        SizedBox(width: ScreenSize.fitPxHeight(13)),
        Expanded(
          child: BaseInputField(
            textInputAction: TextInputAction.search,
            controller: searchController,
            hintText: "搜尋",
            onFieldSubmitted: (value) {
              if (searchController.text == "") {
                return;
              }

              PostPageByTextFilter(searchText: searchController.text).show(context);
            },
          ),
        ),
        MainBtn(
          onPress: () {
            if (searchController.text == "") {
              return;
            }
            FocusScope.of(context).requestFocus(FocusNode());
            PostPageByTextFilter(searchText: searchController.text).show(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.search,
              color: AppColors.whiteColor,
              size: ScreenSize.fontSize16,
            ),
          ),
        ),
      ],
    ),
  );
}
