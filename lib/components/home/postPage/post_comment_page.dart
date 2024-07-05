import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/apiListView/api_list_view.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/account/user_provider.dart';
import 'package:social_mediam_match/provider/post/post_comment_view_model.dart';
import 'package:social_mediam_match/services/post_service.dart';

import '../../../pageManager/setting/route_controller.dart';
import '../../../provider/post/post_comment_provider.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import '../../utilities/style/style_config.dart';

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
        Builder(builder: (context) {
          TextEditingController postCommentInput = context.read<PostCommentProvider>().postCommentInput;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: TextField(
                      controller: postCommentInput,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 5, left: 10),
                        border: OutlineInputBorder(),
                        hintText: 'コメントを追加',
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    PostCommentViewModel(postCommentContext: context)
                        .commetMessageOnCreate(postUID: choicedPost.id, message: postCommentInput.text);
                  },
                  child: Container(
                    height: 30,
                    margin: EdgeInsets.only(left: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: normalBgColor2.withOpacity(0.5)),
                    child: Center(
                      child: Icon(
                        Icons.send,
                        size: 16,
                        color: normalTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: APIListView<PostCommentTextEditorModel>(
              size: 8,
              needToTopWidget: false,
              apiFunc: (page, size) {
                return PostService().getPostCommentData(page, size, choicedPost.id);
              },
              providerList: context.watch<BaseAPIListProvider<PostCommentTextEditorModel>>().listData,
              itemChild: (data, index) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  width: ScreenSize.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///アイコン
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: GestureDetector(
                          onTap: () {
                            openUserDetailEndDrawer(context: context, otherUserData: data[index].commentUserInfo);
                          },
                          child: UserIcon(
                            iconSize: 35,
                            image: data[index].commentUserInfo.image,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///ユーザネーム
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                data[index].commentUserInfo.name != ""
                                    ? data[index].commentUserInfo.name ?? ""
                                    : data[index].commentUserInfo.email,
                                style: const TextStyle(fontSize: 14),
                              ),

                              const SizedBox(width: 8),

                              ///期日
                              Text(
                                data[index].postTime,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          !data[index].isEditor
                              ? Text(
                                  data[index].message,
                                  style: const TextStyle(fontSize: 14),
                                )
                              : SizedBox(
                                  width: ScreenSize.width - 75,
                                  height: 30,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: data[index].textEditingController,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.only(top: -21),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          PostCommentViewModel(postCommentContext: context)
                                              .commetMessageOnChange(data[index], data[index].textEditingController.text);
                                        },
                                        child: const Icon(Icons.check),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          PostCommentViewModel(postCommentContext: context).editerStatusOnChange(data[index]);
                                        },
                                        child: const Icon(Icons.close),
                                      )
                                    ],
                                  ),
                                ),
                          Builder(builder: (context) {
                            LoginUser loginUserData = context.read<UserProvider>().userData;
                            return Visibility(
                              visible: data[index].commentUserInfo.uid == loginUserData.uid,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      PostCommentViewModel(postCommentContext: context).editerStatusOnChange(data[index]);
                                    },
                                    child: const Text(
                                      "編輯",
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      PostCommentViewModel(postCommentContext: context).deleteCommentPostCheck(data[index]);
                                    },
                                    child: const Text(
                                      "刪除",
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                        ],
                      )
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
