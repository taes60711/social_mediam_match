import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';
import '../../components/utilities/style/style_config.dart';
import '../../models/post_model.dart';
import '../../pageManager/enum/route_path.dart';

class MyPostViewModel {
  BuildContext myPostContext;
  MyPostViewModel({required this.myPostContext});

  Future<void> deletePost({required int postId}) async {
    print(postId);
  }

  Future<void> deletePostCheck({required int postId}) {
    return showDialog<void>(
      context: myPostContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('確定要刪除該篇文章嗎?'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('確定'),
              onPressed: () async {
                await deletePost(postId: postId);
                RouteOptions.pop();
              },
            ),
            ElevatedButton(
              child: const Text('取消'),
              onPressed: () {
                RouteOptions.pop();
              },
            ),
          ],
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
                                    RouteOptions.pushTo(RoutePath.postEditPage.value, arguments: {
                                      'postData': choicedPost,
                                      'postContext': myPostContext,
                                    });
                                  }),
                              _bottomSheetBtn(
                                  icon: FontAwesomeIcons.commentSlash,
                                  btnText: "刪除",
                                  bntFunc: () {
                                    deletePostCheck(postId: choicedPost.id);
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
