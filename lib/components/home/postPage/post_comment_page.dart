import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/services/post_service.dart';

import '../../../pageManager/setting/route_controller.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';

class PostCommentPage extends StatelessWidget {
  final PostModel choicedPost;
  const PostCommentPage({super.key, required this.choicedPost});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseTopBar(
          leftWidget: Container(),
          title: "留言",
          rightWidget: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () => RouteOptions.pop(),
              child: const Icon(
                Icons.close,
                size: 25,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: APIListView<PostCommentModel>(
              size: 8,
              apiFunc: (page, size) {
                return PostService().getPostCommentData(page, size, choicedPost.id);
              },
              providerList: context.watch<BaseAPIListProvider<PostCommentModel>>().listData,
              itemChild: (data, index) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  width: ScreenSize.width,
                  child: Row(
                    children: [
                      ///アイコン
                      GestureDetector(
                        onTap: () {
                          // openUserDetailEndDrawer(context: context, otherUserData: data[index].commentUserInfo);
                        },
                        child: UserIcon(
                          iconSize: 35,
                          image: data[index].commentUserInfo.image,
                        ),
                      ),
                      const SizedBox(width: 10),

                      ///ユーザネーム
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                data[index].commentUserInfo.name != ""
                                    ? data[index].commentUserInfo.name ?? ""
                                    : data[index].commentUserInfo.email,
                                style: TextStyle(fontSize: 14),
                              ),

                              ///期日
                              Text(
                                "${data[index].postTime}",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Text(
                            "${data[index].message}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              loadingBuilder: () {
                return Container();
              },
              noDataBuilder: Center(
                child: Text("コメントありません"),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
