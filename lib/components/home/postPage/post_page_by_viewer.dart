import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../global.dart';
import '../../../global/global_view_model.dart';
import '../../../models/post_model.dart';

import '../../../provider/post/post_view_model.dart';
import '../../../services/post_service.dart';
import '../../utilities/BottomSheets/base_bottom_sheet.dart';
import '../../utilities/Stateful_wrapper.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/loading.dart';
import '../../utilities/rich_text_view.dart';

import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_utilities.dart';

class PostPageByViewer extends StatefulWidget {
  final PostViewModel postPageForumViewModel;
  const PostPageByViewer({super.key, required this.postPageForumViewModel});

  @override
  State<PostPageByViewer> createState() => _PostPageByViewerState();
}

class _PostPageByViewerState extends State<PostPageByViewer> {
  late PostViewModel postPageByViewerViewModel;

  @override
  void initState() {
    postPageByViewerViewModel = PostViewModel(context: context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        globalPostContext = context;
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Builder(
            builder: (context) {
              return APIListView<PostModel>(
                providerList: context.watch<BaseAPIListProvider<PostModel>>().listData,
                apiFunc: (page, size) {
                  return PostService().getPostDataByViewer(page, size);
                },

                ///文章作るボタン
                customFloatbutton: PostViewUtilities.postCreateButton(context),
                itemChild: ((data, index) {
                  return GestureDetector(
                    onLongPress: () {
                      context.read<BaseAPIListProvider<PostModel>>().onChoiceData(choicedData: data[index]);
                      postPageByViewerViewModel.showOptionBottomSheet(choicedPost: data[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        children: [
                          ///文章プレビュー
                          GestureDetector(
                            onTap: () {
                              postPageByViewerViewModel.postDetailInit(choicedPost: data[index]);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Title
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5, top: 3, bottom: 3),
                                    child: Text(
                                      data[index].title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  /// 文章プレビュー
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: RichTextView(
                                      content: data[index].mainMessage,
                                      isPreView: true,
                                    ),
                                  ),

                                  Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                                      height: 0.2,
                                      color: normalBgColor2),

                                  ///文章bottomBar
                                  bottomBar(context: context, data: data[index]),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, top: 2),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                color: Colors.black38,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                postPageByViewerViewModel.getBoardName(data[index]),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12),
                                          child: PostViewUtilities().iconWithText(
                                            iconData: FontAwesomeIcons.eye,
                                            text: "${data[index].viewed}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                loadingBuilder: () {
                  return const PostLoading();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

///文章bottomBar
Widget bottomBar({required BuildContext context, required PostModel data}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            openUserDetailEndDrawer(context: context, otherUserData: data.postUserInfo);
          },
          child: UserIcon(
            iconSize: 28,
            image: data.postUserInfo.image,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              ///いいね数
              PostViewUtilities().iconWithText(
                iconData: FontAwesomeIcons.heart,
                iconColor: const Color.fromARGB(255, 248, 110, 110),
                text: "${data.good}",
              ),

              const SizedBox(width: 8),

              ///コメント数
              PostViewUtilities().iconWithText(
                iconData: FontAwesomeIcons.comment,
                iconColor: Colors.blueAccent,
                text: "${data.commentCount}",
              ),
              const SizedBox(width: 13),

              ///設定ボタン
              GestureDetector(
                onTap: () {
                  context.read<BaseAPIListProvider<PostModel>>().onChoiceData(choicedData: data);
                  PostViewModel(context: context).showOptionBottomSheet(choicedPost: data);
                },
                child: Container(
                  width: 30,
                  alignment: Alignment.centerLeft,
                  color: Colors.transparent,
                  child: const Icon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    color: Colors.black87,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        ///期日
        Text(
          "${data.postTime}${tr("skExChpage_beforDays")}",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
  );
}

// new
class PostByView extends ConsumerStatefulWidget {
  const PostByView({super.key});

  @override
  ConsumerState<PostByView> createState() => _PostByViewState();
}

List<PostModel> topPosts = [];

class _PostByViewState extends ConsumerState<PostByView> {
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
    return Column(
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
                                        const SizedBox(width: 5),
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
                                height: ScreenSize.fitPxHeight(74),
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 10),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              itemChild: (data, index) {
                return Container(
                  width: ScreenSize.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  margin: const EdgeInsets.only(bottom: 10),
                  color: AppColors.black37,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, right: 5),
                        child: UserIcon(
                          iconSize: 24,
                          image: data.postUserInfo.image,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data.postUserInfo.name ?? "",
                                  style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                                ),
                                const Expanded(child: SizedBox(width: 1)),
                                Container(
                                  width: 30,
                                  alignment: Alignment.centerRight,
                                  color: Colors.transparent,
                                  child: Icon(
                                    FontAwesomeIcons.ellipsis,
                                    color: AppColors.greyColor130,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              data.title,
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                            SizedBox(height: 5),
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
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
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
