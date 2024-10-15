// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_comment_page.dart';
import 'package:social_mediam_match/models/user_model.dart';
import 'package:social_mediam_match/provider/post/post_provider.dart';

import '../../components/utilities/apiListView/base_api_list_provider.dart';
import '../../components/utilities/basic_top_bar.dart';
import '../../components/utilities/endDrawers/post_comment_end_drawer.dart';
import '../../components/utilities/style/style_config.dart';
import '../../global.dart';
import '../../models/post_model.dart';
import '../../models/rich_text_format.dart';
import '../../pageManager/setting/route_controller.dart';
import '../../services/post_service.dart';
import '../account/user_provider.dart';
import 'post_comment_provider.dart';

class PostViewModel {
  BuildContext postContext;
  PostViewModel({required this.postContext});

  Future<void> getAllPostBoard() async {
    List<PostBoard> requestBoardData = await PostService().getAllPostBoard();
    postContext.read<PostProvider>().getAllPostBoard(requestBoardData);
  }

  Future<void> getTopPost() async {
    List<PostModel> requestPostData = await PostService().getPostByType(0, 3, -1);
    postContext.read<PostProvider>().getTopPost(requestPostData);
  }

  Future<void> postDetailInit({required PostModel choicedPost}) async {
    openPostDetailEndDrawer(context: postContext, choicedPost: choicedPost);
    LoginUser userData = postContext.read<UserProvider>().userData;
    bool isGood = await PostService().checkIsPostGood(postId: choicedPost.id, userUID: userData.uid);
    postContext.read<PostProvider>().changeIsGoodStatus(isGood);

    if (choicedPost.createdBy != userData.uid) {
      await PostService().updatePostViewCount(choicedPost.id);
      if (choicedPost.type != -1) {
        choicedPost.viewed++;
        globalPostContext?.read<BaseAPIListProvider<PostModel>>().onChoiceData(choicedData: choicedPost);
        globalPostContext?.read<BaseAPIListProvider<PostModel>>().editData(updatedData: choicedPost);
      }
    }
  }

  Future<void> createPost({required String title, required String msg, required int type}) async {
    LoginUser userData = postContext.read<UserProvider>().userData;
    String fomattedContent = await RichTextFormat(htmlString: msg).sendPostImgFormat();

    await PostService().createPost(userData.uid, title, fomattedContent, type);

    PostModel createdData = PostModel(
      id: 0,
      createdBy: userData.uid,
      title: title,
      mainMessage: fomattedContent,
      postTime: PostModel.dateFormatted(DateTime.now().toUtc().toString()),
      type: type,
      postUserInfo: userData,
    );

    postContext.read<BaseAPIListProvider<PostModel>>().createData(createdData: createdData);
  }

  Future<void> updatePostGood({required bool isGood, required PostModel viewChoicedPost}) async {
    LoginUser userData = postContext.read<UserProvider>().userData;
    globalPostContext?.read<BaseAPIListProvider<PostModel>>().onChoiceData(choicedData: viewChoicedPost);
    if (isGood) {
      await PostService().updatePostGood(viewChoicedPost.id);
      postContext.read<PostCommentProvider>().updateChoicedPostGoodCount(isPlus: false);
    } else {
      await PostService().updatePostGood(viewChoicedPost.id, userUID: userData.uid);
      postContext.read<PostCommentProvider>().updateChoicedPostGoodCount(isPlus: true);
    }
    globalPostContext?.read<BaseAPIListProvider<PostModel>>().editData(updatedData: viewChoicedPost);
    postContext.read<PostProvider>().changeIsGoodStatus(!isGood);
  }

  Future<void> searchPostByTextFilter(String keyword) async {
    int loadSize = postContext.read<BaseAPIListProvider<PostModel>>().size;

    await postContext.read<BaseAPIListProvider<PostModel>>().replaceApiFunc(
      loadSize,
      replaceApiFunc: (page, size) {
        return PostService().getPostByTextFilter(page, size, keyword);
      },
    );
  }

  void showOptionBottomSheet({required PostModel choicedPost}) {
    showModalBottomSheet(
        context: globalContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.25,
              initialChildSize: 0.3,
              maxChildSize: 0.3,
              builder: (context, scrollController) {
                return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        BaseTopBar(
                          leftWidget: Container(),
                          centerWidget: Icon(
                            Icons.remove,
                            size: 35,
                            color: normalBgColor2,
                          ),
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
                          child: Column(
                            children: [
                              _bottomSheetBtn(
                                  icon: Icons.edit,
                                  btnText: "分享",
                                  bntFunc: () {
                                    RouteOptions.pop();
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ));
              });
        });
  }

  void showPostCommentPageSheet({required PostModel choicedPost}) {
    showModalBottomSheet(
        context: postContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => BaseAPIListProvider<PostCommentTextEditorModel>()),
              ChangeNotifierProvider(create: (_) => PostCommentProvider()),
            ],
            child: DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.55,
              initialChildSize: 0.6,
              maxChildSize: 0.6,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: PostCommentPage(choicedPost: choicedPost),
                );
              },
            ),
          );
        });
  }

  /// 掲示板の名前取得する
  String getBoardName(List<PostBoard> allPostBoards, PostModel post) {
    String result = "";
    if (post.type != -1) {
      result = allPostBoards.firstWhere((e) {
        return e.type == post.type;
      }).name;
    }
    return result;
  }
}

Widget _bottomSheetBtn({required IconData icon, required String btnText, required bntFunc}) {
  return GestureDetector(
    onTap: () {
      bntFunc();
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: normalBgColor2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: normalTextColor,
            size: 25,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Text(
              btnText,
              style: TextStyle(color: normalTextColor),
            ),
          ),
        ],
      ),
    ),
  );
}
