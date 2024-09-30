import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import 'package:social_mediam_match/services/post_service.dart';
import '../../components/utilities/apiListView/base_api_list_provider.dart';
import '../../components/utilities/style/style_config.dart';
import '../../global.dart';
import '../../models/post_model.dart';
import '../../models/rich_text_format.dart';
import '../../pageManager/enum/route_path.dart';
import '../account/user_provider.dart';
import 'post_provider.dart';

class MyPostViewModel {
  BuildContext myPostContext;
  MyPostViewModel({required this.myPostContext});

  Future<void> updatePost({required String title, required String updateMsg}) async {
    PostModel updatedData = myPostContext.read<BaseAPIListProvider<PostModel>>().choiceData ?? PostModel();
    String fomattedContent = await RichTextFormat(htmlString: updateMsg).sendPostImgFormat();
    updatedData.mainMessage = fomattedContent;
    await PostService().updatePost(postId: updatedData.id, title: title, mainMessage: updatedData.mainMessage).then(
      (isSucess) async {
        if (isSucess) {
          myPostContext.read<BaseAPIListProvider<PostModel>>().reloadData(
                apiFunc: () async => await PostService().getPostDataByUID(0, 5, myPostContext.read<UserProvider>().userData),
              );
          int preLoadPage = myPostContext.read<BaseAPIListProvider<PostModel>>().page;
          await myPostContext.read<BaseAPIListProvider<PostModel>>().preLoad(
                apiFunc: () async =>
                    await PostService().getPostDataByUID(preLoadPage, 5, myPostContext.read<UserProvider>().userData),
              );
        }
      },
    );
  }

  Future<void> deletePostCheck() {
    return showDialog<void>(
      context: globalContext,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(15),
            width: 150,
            height: 160,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Expanded(
                  child: Text('確定要刪除該篇文章嗎?'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextBtn(
                        title: '取消',
                        titleColor: normalTextColor,
                        btnColor: hintTextColor,
                        onPress: () {
                          RouteOptions.pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextBtn(
                        title: '確認',
                        titleColor: normalTextColor,
                        btnColor: normalBgColor,
                        onPress: () async {
                          PostModel wantDeletePost =
                              myPostContext.read<BaseAPIListProvider<PostModel>>().choiceData ?? PostModel();
                          await PostService().deletePost(wantDeletePost.id).then((isSucess) {
                            if (isSucess) {
                              myPostContext.read<BaseAPIListProvider<PostModel>>().deleteData(choiceData: wantDeletePost);
                              RouteOptions.pop();
                              RouteOptions.pop();
                            }
                          });
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showOptionBottomSheet({required PostModel choicedPost}) {
    showModalBottomSheet(
        context: myPostContext,
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
                                  btnText: "編輯文章",
                                  bntFunc: () {
                                    RouteOptions.pop();
                                    RouteOptions.pushTo(
                                      RoutePath.postEditPage,
                                      arguments: {
                                        'postContext': myPostContext,
                                        'postBoradType': myPostContext.read<BaseAPIListProvider<PostModel>>().choiceData!.type,
                                        'allPostBoradTypeList': myPostContext.read<PostProvider>().allPostBoards,
                                        'editorType': "update",
                                      },
                                    );
                                  }),
                              _bottomSheetBtn(
                                  icon: FontAwesomeIcons.commentSlash,
                                  btnText: "刪除",
                                  bntFunc: () {
                                    deletePostCheck();
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ));
              });
        });
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
