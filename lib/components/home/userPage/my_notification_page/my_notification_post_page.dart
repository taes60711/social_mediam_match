import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../enum/date_format_utilities.dart';
import '../../../../models/post_model.dart';
import '../../../../provider/post/post_view_model.dart';
import '../../../utilities/BottomSheets/user_profile_bottom_sheet.dart';
import '../../../utilities/appBar/basic_top_bar.dart';
import '../../../utilities/endDrawers/base_end_drawer.dart';
import '../../../utilities/rich_text_view.dart';
import '../../../utilities/style/screen_size.dart';
import '../../../utilities/style/style_config.dart';
import '../../../utilities/user_icon.dart';

class MyNotificationPostPage extends BaseEndDrawer {
  final PostModel data;
  MyNotificationPostPage({required this.data});
  @override
  bool needWaitOpenPage() {
    return true;
  }

  late PostViewModel viewModel;

  @override
  Future<void> initState(WidgetRef ref) async {
    viewModel = PostViewModel(ref: ref, context: context, render: render);
  }

  @override
  Widget build(ref) {
    PostModel choiceData = data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///タイトルバー
        BaseTopBar(
          backFunc: () => closePage(),
          title: choiceData.title,
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(15)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// ユーザデータ
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ///ユーザー詳細ページに遷移
                          UserProfileAllInfoBottomSheet(userData: choiceData.postUserInfo).show(context);
                        },
                        child: UserIcon(
                          iconSize: ScreenSize.fitPxWidth(30),
                          image: choiceData.postUserInfo.image,
                        ),
                      ),
                      SizedBox(width: ScreenSize.fitPxWidth(5)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            choiceData.postUserInfo.name ?? "",
                            style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
                          ),
                          Text(
                            DateFormatUtilities().format(choiceData.postTime),
                            style: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize12),
                          ),
                        ],
                      )
                    ],
                  ),

                  /// MainMessage
                  RichTextView(content: choiceData.mainMessage),
                  SizedBox(height: ScreenSize.fitPxWidth(10)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
