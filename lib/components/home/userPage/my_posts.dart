import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import '../../../models/user_model.dart';
import '../../../provider/account/user_provider.dart';
import '../../../provider/post/post_provider.dart';
import '../../../services/post_service.dart';
import '../../utilities/BottomSheets/user_profile_bottom_sheet.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/loading.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import '../postPage/post_detail_page.dart';
import '../postPage/post_utilities.dart';

class MyPostPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    ProfileData userData = ref.watch(loginUserData);
    return Column(
      children: [
        BaseTopBar(
          title: "我的文章",
          backFunc: () {
            closePage();
          },
        ),
        Expanded(
          child: APIListWidget(
              size: 6,
              apiFunc: (page, size) {
                return PostService().getPostDataByUID(page, size, userData);
              },
              listControllerProvider: myPostlistControllerProvider,
              noDataWidget: PostViewUtilities.noPostData(),
              loadingWidget: const PostLoading(),
              itemChild: (data, index) {
                return MainBtn(
                  onPress: () {
                    ref.read(choicedPostProvider.notifier).update((state) => data);
                    PostDetailPage().show(context);
                  },
                  child: Container(
                    width: ScreenSize.width,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(bottom: 10),
                    color: AppColors.black37,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            UserProfileBottomSheet(userData: data.postUserInfo).show(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: ScreenSize.fitPxHeight(2), right: ScreenSize.fitPxWidth(5)),
                            child: UserIcon(
                              iconSize: 30,
                              image: data.postUserInfo.image,
                            ),
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
                                  SizedBox(width: ScreenSize.fitPxWidth(4)),

                                  ///期日
                                  Text(
                                    "${data.postTime}${tr("skExChpage_beforDays")}",
                                    style: TextStyle(fontSize: ScreenSize.fontSize10, color: AppColors.greyColor130),
                                  ),
                                  const Expanded(child: SizedBox(width: 1)),
                                  Container(
                                    width: 30,
                                    alignment: Alignment.centerRight,
                                    color: Colors.transparent,
                                    child: Icon(
                                      FontAwesomeIcons.ellipsis,
                                      color: AppColors.greyColor130,
                                      size: ScreenSize.fontSize16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                data.title,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: ScreenSize.fontSize16,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                        style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 5),

                                  ///View数
                                  PostViewUtilities().iconWithText(
                                      iconData: FontAwesomeIcons.eye,
                                      iconColor: Color.fromARGB(255, 110, 124, 129),
                                      text: "${data.viewed}",
                                      style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),

                                  const SizedBox(width: 10),

                                  ///いいね数
                                  PostViewUtilities().iconWithText(
                                      iconData: FontAwesomeIcons.heart,
                                      iconColor: const Color.fromARGB(255, 248, 110, 110),
                                      text: "${data.good}",
                                      style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
                                  const SizedBox(width: 8),

                                  ///コメント数
                                  PostViewUtilities().iconWithText(
                                      iconData: FontAwesomeIcons.commentDots,
                                      iconColor: Colors.blueAccent,
                                      text: "${data.commentCount}",
                                      style: TextStyle(fontSize: ScreenSize.fontSize12, color: AppColors.whiteColor)),
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
                                ],
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
