import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/api_page.dart';
import '../../../../enum/date_format_utilities.dart';
import '../../../../models/post_model.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../../services/post_service.dart';
import '../../../utilities/BottomSheets/user_profile_bottom_sheet.dart';
import '../../../utilities/appBar/basic_top_bar.dart';
import '../../../utilities/endDrawers/base_end_drawer.dart';
import '../../../utilities/rich_text_view.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/app_colors.dart';
import '../../../utilities/user_icon.dart';

class MyNotificationPostPage extends BaseEndDrawer {
  final String postId;
  MyNotificationPostPage({required this.postId});

  @override
  bool needWaitOpenPage() {
    return true;
  }

  late PostViewModel viewModel;

  @override
  Widget build(ref) {
    return APIPage<PostModel>(
      noDataCondition: (data) {
        return data.id == -1;
      },
      apiFunc: () async {
        return await PostService().getPostDataByPostId(int.parse(postId));
      },
      initFunc: (PostModel data) async {
        viewModel = PostViewModel(ref: ref, context: context, render: render);
      },
      child: (PostModel data) {
        return Column(
          children: [
            ///タイトルバー
            BaseTopBar(
              backFunc: () => closePage(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
                  child: Column(
                    children: [
                      /// ユーザデータ
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ///ユーザー詳細ページに遷移
                              UserProfileAllInfoBottomSheet(userData: data.postUserInfo).show(context);
                            },
                            child: UserIcon(
                              iconSize: ScreenSize.fitPxWidth(30),
                              image: data.postUserInfo.image,
                            ),
                          ),
                          SizedBox(width: ScreenSize.fitPxWidth(5)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.postUserInfo.name ?? "",
                                style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                              ),
                              Text(
                                DateFormatUtilities().format(data.postTime),
                                style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                              ),
                            ],
                          )
                        ],
                      ),

                      /// MainMessage
                      RichTextView(content: data.mainMessage),
                      SizedBox(height: ScreenSize.fitPxWidth(10)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      nodataWidget: Column(
        children: [
          ///タイトルバー
          BaseTopBar(
            backFunc: () => closePage(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: ScreenSize.fitPxHeight(8)),
                  child: Icon(
                    FontAwesomeIcons.commentSlash,
                    size: 50,
                    color: AppColors.whiteColor,
                  ),
                ),
                SizedBox(height: ScreenSize.fitPxHeight(10)),
                Text(
                  "沒有文章",
                  style: TextStyle(
                    fontSize: ScreenSize.fontSize20,
                    color: AppColors.greyColor130,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
