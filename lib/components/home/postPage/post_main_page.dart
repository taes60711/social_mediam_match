import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';

import '../../../global/global_view_model.dart';
import '../../../models/post_model.dart';
import '../../../services/post_service.dart';
import '../../utilities/BottomSheets/base_bottom_sheet.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/endDrawers/custom_end_drawer.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_utilities.dart';

class PostMainPage extends ConsumerStatefulWidget {
  const PostMainPage({super.key});

  @override
  ConsumerState<PostMainPage> createState() => _PostMainPageState();
}

bool topPostExpansion = false;
double listScrollStartPos = 0;
bool isScrollUp = false;

List<PostModel> topPosts = [];
PageController pageController = PageController();
int pageIndex = 0;

class _PostMainPageState extends ConsumerState<PostMainPage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    topPosts = await PostService().getPostByType(0, 3, -1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tWidget = [
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
            children: tWidget,
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
                GestureDetector(
                  onTap: () {
                    BaseEndDrawer().show(context);
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
                          child: Icon(Icons.search, color: AppColors.greyColor54),
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
                ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostByView extends ConsumerStatefulWidget {
  const PostByView({super.key});

  @override
  ConsumerState<PostByView> createState() => _PostByViewState();
}

class _PostByViewState extends ConsumerState<PostByView> {
  @override
  Widget build(BuildContext context) {
    return listenListView(
      context,
      child: Column(
        children: [
          Container(
            height: ref.watch(bottomNavationBarPosProvider) != ScreenSize.fitPxHeight(-60) ? 85 : 40,
          ),
          Expanded(
            child: APIListWidget(
                apiFunc: (page, size) {
                  return PostService().getPostDataByViewer(page, size);
                },
                listControllerProvider: listControllerProvider,
                upWidget: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: ScreenSize.width,
                        color: AppColors.black37,
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenSize.fitPxHeight(8),
                          horizontal: ScreenSize.fitPxHeight(15),
                        ),
                        child: topPosts.isEmpty
                            ? Container()
                            : CarouselSlider(
                                items: topPosts.map((e) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Hot!",
                                        style: TextStyle(color: AppColors.redColor, fontSize: 12),
                                      ),
                                      Text(
                                        e.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: AppColors.whiteColor),
                                      ),
                                      SizedBox(height: ScreenSize.fitPxHeight(10)),
                                      Container(
                                        width: ScreenSize.width,
                                        height: .5,
                                        color: AppColors.greyColor98.withOpacity(.7),
                                      ),
                                      SizedBox(height: ScreenSize.fitPxHeight(5)),
                                      Row(
                                        children: [
                                          Text(
                                            "作成者:",
                                            style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                                          ),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () {
                                              BaseBottomSheet().show(
                                                context,
                                                child: userProfileView(),
                                              );
                                            },
                                            child: UserIcon(
                                              iconSize: 20,
                                              image: e.postUserInfo.image,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            e.postUserInfo.name ?? "",
                                            style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                    height: 78,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 1,
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(seconds: 2)),
                              ),
                      ),
                    ),
                  ],
                ),
                itemChild: (data, index) {
                  return Container(
                    width: ScreenSize.width,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(bottom: 10),
                    color: AppColors.black37,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Row(
                          children: [
                            const SizedBox(width: 5),
                            UserIcon(
                              iconSize: 24,
                              image: data.postUserInfo.image,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              data.postUserInfo.name ?? "",
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                            Expanded(child: SizedBox(width: 1)),
                            Container(
                              width: 30,
                              alignment: Alignment.centerRight,
                              color: Colors.transparent,
                              child: Icon(
                                FontAwesomeIcons.ellipsis,
                                color: Color.fromARGB(221, 180, 179, 179),
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          data.title,
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: RichTextView(
                              content: data.mainMessage,
                              isPreView: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  color: const Color.fromARGB(96, 175, 170, 170),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Techology",
                                  style: TextStyle(fontSize: 12, color: AppColors.whiteColor),
                                ),
                              ],
                            ),
                            const SizedBox(width: 5),

                            ///View数
                            PostViewUtilities().iconWithText(
                                iconData: FontAwesomeIcons.eye,
                                iconColor: Color.fromARGB(255, 110, 124, 129),
                                text: "${data.viewed}",
                                style: TextStyle(fontSize: 12, color: AppColors.whiteColor)),

                            const SizedBox(width: 10),

                            ///いいね数
                            PostViewUtilities().iconWithText(
                                iconData: FontAwesomeIcons.heart,
                                iconColor: const Color.fromARGB(255, 248, 110, 110),
                                text: "${data.good}",
                                style: TextStyle(color: AppColors.whiteColor)),
                            const SizedBox(width: 8),

                            ///コメント数
                            PostViewUtilities().iconWithText(
                                iconData: FontAwesomeIcons.comment,
                                iconColor: Colors.blueAccent,
                                text: "${data.commentCount}",
                                style: TextStyle(color: AppColors.whiteColor)),
                            const SizedBox(width: 13),

                            ///シャアボタン
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 30,
                                alignment: Alignment.centerLeft,
                                color: Colors.transparent,
                                child: const Icon(
                                  FontAwesomeIcons.arrowUpRightFromSquare,
                                  color: Color.fromARGB(221, 180, 179, 179),
                                  size: 14,
                                ),
                              ),
                            ),

                            Expanded(child: SizedBox(width: 1)),

                            ///期日
                            Text(
                              "${data.postTime}${tr("skExChpage_beforDays")}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  ///LisViewの状態をリスン
  Widget listenListView(BuildContext context, {required child}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        /// only listen depth list == 0
        if (scrollNotification.depth != 0) {
          return false;
        }

        if (scrollNotification is ScrollStartNotification) {
          listScrollStartPos = scrollNotification.metrics.pixels;
        }

        if (scrollNotification is ScrollUpdateNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;
          // final max = scrollNotification.metrics.maxScrollExtent;
          bool isScrollingUp = scrollPosition < listScrollStartPos;
          if (!isScrollUp) {
            if (isScrollingUp) {
              GlobalViewModel().bottomBarHideStateChage(false);
              isScrollUp = true;
            }
          } else {
            if (!isScrollingUp) {
              GlobalViewModel().bottomBarHideStateChage(true);
              isScrollUp = false;
            }
          }
        }
        if (scrollNotification is ScrollEndNotification) {
          // final scrollPosition = scrollNotification.metrics.pixels;
        }
        return false;
      },
      child: child,
    );
  }

  Widget userProfileView() {
    return Column(
      children: [
        SizedBox(height: ScreenSize.fitPxHeight(10)),
        Container(
          width: ScreenSize.fitPxHeight(80),
          height: ScreenSize.fitPxHeight(80),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(
              ScreenSize.fitPxHeight(80),
            ),
          ),
        ),
        SizedBox(height: ScreenSize.fitPxHeight(10)),
        Container(
          width: ScreenSize.width,
          margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxHeight(20)),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.fitPxHeight(10),
            vertical: ScreenSize.fitPxHeight(10),
          ),
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "userName",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: ScreenSize.fontSize18,
                ),
              ),
              Text(
                "userName@gmail.com",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenSize.fontSize12,
                ),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(15)),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.fitPxHeight(10),
                      vertical: ScreenSize.fitPxHeight(5),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.greyColor54,
                    ),
                    child: Text(
                      "新增好友",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: ScreenSize.fitPxHeight(15)),
      ],
    );
  }
}
