import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/home/postPage/post_utilities.dart';
import '../../../global/global_view_model.dart';
import '../../../models/user_model.dart';
import '../../../provider/post/post_view_model.dart';
import '../../../services/post_service.dart';
import '../../utilities/BottomSheets/base_bottom_sheet.dart';
import '../../utilities/apiListView/api_list_controller.dart';
import '../../utilities/apiListView/api_list_view.dart';
import '../../utilities/loading.dart';
import '../../utilities/rich_text_view.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';
import '../../utilities/user_icon.dart';
import 'post_main_page.dart';

final newlistControllerProvider = StateNotifierProvider<APIListControllerNotifier, APIListController>(
  (ref) => APIListControllerNotifier(APIListController()),
);

// new
class PostByNew extends ConsumerStatefulWidget {
  const PostByNew({super.key});

  @override
  ConsumerState<PostByNew> createState() => _PostByViewState();
}

class _PostByViewState extends ConsumerState<PostByNew> {
  late PostViewModel postPageByNewViewModel;

  @override
  void initState() {
    postPageByNewViewModel = PostViewModel(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostViewUtilities().topPadding(
          ref.watch(bottomNavationBarPosProvider),
          ref.watch(topPostProvider).isNotEmpty,
        ),
        Expanded(
          child: APIListWidget(
              apiFunc: (page, size) {
                return PostService().getNewPosts(page, size);
              },
              listControllerProvider: newlistControllerProvider,
              loadingWidget: const PostLoading(),
              noDataWidget: PostViewUtilities.noPostData(),
              itemChild: (data, index) {
                return Container(
                  width: ScreenSize.width,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  margin: const EdgeInsets.only(bottom: 10),
                  color: AppColors.black37,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          BaseBottomSheet().show(
                            context,
                            child: userProfileView(userData: data.postUserInfo),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5, right: 5),
                          child: UserIcon(
                            iconSize: 24,
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
                                    iconData: FontAwesomeIcons.comment,
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

                                Expanded(child: SizedBox(width: 1)),

                                ///期日
                                Text(
                                  "${data.postTime}${tr("skExChpage_beforDays")}",
                                  style: TextStyle(fontSize: ScreenSize.fontSize12, color: Colors.grey),
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

  Widget userProfileView({required LoginUser userData}) {
    return Column(
      children: [
        SizedBox(height: ScreenSize.fitPxHeight(10)),
        UserIcon(
          image: userData.image,
          iconSize: ScreenSize.fitPxHeight(80),
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      userData.name ?? "",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize18,
                      ),
                    ),
                  ),
                  Text(
                    "${userData.lastLogin}${tr("skExChpage_beforDays")}",
                    style: TextStyle(
                      color: AppColors.greyColor130,
                      fontSize: ScreenSize.fontSize12,
                    ),
                  ),
                ],
              ),
              Text(
                userData.email,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenSize.fontSize12,
                ),
              ),
              Text(
                userData.introduction ?? "",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: ScreenSize.fontSize12,
                ),
              ),
              SizedBox(height: ScreenSize.fitPxHeight(15)),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.fitPxHeight(15),
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
                "職業",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: ScreenSize.fontSize14,
                ),
              ),
              Text(
                userData.job ?? "",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: ScreenSize.fontSize12,
                ),
              ),
              Row(
                children: [
                  Text(
                    "信箱認證",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: ScreenSize.fontSize14,
                    ),
                  ),
                  SizedBox(width: ScreenSize.fitPxWidth(10)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ScreenSize.fitPxWidth(5),
                        ),
                        color: userData.isEmailVerified ? Color.fromARGB(255, 68, 197, 72) : AppColors.greyColor98),
                    child: Text(
                      userData.isEmailVerified ? "已認證" : "未認證",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: ScreenSize.fontSize14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenSize.fitPxHeight(5)),
            ],
          ),
        ),
        SizedBox(height: ScreenSize.fitPxHeight(15)),
      ],
    );
  }
}
