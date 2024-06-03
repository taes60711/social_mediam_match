import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/post_state.dart';
import '../../../global.dart';
import '../../../models/user_model.dart';
import '../../utilities/style/style_config.dart';
import '../skillExChangePage/user_detail.dart';
import 'post_body.dart';

class PostPageByType extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  final int type;

  const PostPageByType({super.key, required this.type, required this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    PostState postState = context.read<PostState>();
    List<PostModel> postData = context.select((PostState value) => value.postData);
    bool isFirstLoading = context.select((PostState value) => value.isFirstLoading);
    bool isDataAddLoding = context.select((PostState value) => value.isDataAddLoding);
    bool isReLoading = context.select((PostState value) => value.isReLoading);
    GlobalKey<ScaffoldState> globalKey = context.select((PostState value) => value.globalKey);
    LoginUser? otherUser = context.select((PostState value) => value.otherUser);
    bool isCanLoading = context.select((PostState value) => value.isCanLoading);

    double startScrollPosition = context.select((PostState value) => value.startScrollPosition);
    ScrollController scrollController = ScrollController();
    bool floatButtonIsVisiable = context.select((PostState value) => value.floatButtonIsVisiable);
    print("NewsPostPage isFirstLoading: ${isFirstLoading}");
    return StatefulWrapper(
      onInit: () async {
        Future.delayed(Duration(milliseconds: 200))
            .then((value) async => await postState.getPostDataByType(type, searchType: "First"));
      },
      child: isFirstLoading
          ? const PostLoading()
          : Scaffold(
              key: globalKey,
              endDrawer: UserDetail(
                globalKey: globalKey,
                userData: userData,
                otherUser: otherUser,
                gotoFriendPage: gotoFriendPage,
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: normalTextColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed(RoutePath.postEditPage.value, arguments: {
                        "userData": userData,
                        "postState": postState,
                        "type": type,
                      });
                    },
                    child: Icon(
                      FontAwesomeIcons.penToSquare,
                      size: 16,
                      color: normalBgColor,
                    ),
                  ),
                  Visibility(
                    visible: floatButtonIsVisiable,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: normalBgColor2,
                      onPressed: () {
                        scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: const Icon(
                        FontAwesomeIcons.angleUp,
                        size: 16,
                      ),
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    isReLoading
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: Loading(),
                          )
                        : Container(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollNotification) {
                            if (scrollNotification is ScrollStartNotification) {
                              postState.getStartScrollPos(scrollNotification.metrics.pixels);
                            } else if (scrollNotification is ScrollUpdateNotification) {
                              final scrollPosition = scrollNotification.metrics.pixels;
                              final max = scrollNotification.metrics.maxScrollExtent;
                              if (!isDataAddLoding && !isReLoading) {
                                if (scrollPosition > max && isCanLoading && !isDataAddLoding) {
                                  postState.canLoadingChange(false);
                                  postState.addData();
                                } else if (startScrollPosition <= 0.0) {
                                  if (scrollPosition < 0 && isCanLoading && !isReLoading) {
                                    postState.canLoadingChange(false);
                                    postState.reLoadingPage();
                                  }
                                }
                                postState.floatButtonVisiableChange(scrollPosition);
                              }
                              if (!isCanLoading) {
                                if (scrollNotification.dragDetails == null) {
                                  postState.canLoadingChange(true);
                                }
                              }
                            }
                            if (scrollNotification is ScrollEndNotification) {
                              if (isDataAddLoding && isCanLoading) {
                                postState.getPostDataByType(type, searchType: "AddData");
                              } else if (isReLoading && isCanLoading) {
                                postState.getPostDataByType(type, searchType: "Reload");
                              }
                            }
                            return false;
                          },
                          child: postData.isEmpty
                              ? const NoPostData()
                              : ListView.builder(
                                  itemCount: postData.length,
                                  controller: scrollController,
                                  itemBuilder: (context, index) {
                                    Widget mainBody = PostBody(
                                      postData: postData[index],
                                      postState: postState,
                                      globalKey: globalKey,
                                      userData: userData,
                                      gotoFriendPage: gotoFriendPage,
                                      bottomSheetFuncs: [
                                        PostOption(
                                            icon: Icons.link,
                                            buttonFunc: () async {
                                              print("分享");
                                            },
                                            funcText: '分享'),
                                      ],
                                    );
                                    return index != postData.length - 1
                                        ? mainBody
                                        : Column(
                                            children: [
                                              mainBody,
                                              isDataAddLoding
                                                  ? const Padding(
                                                      padding: EdgeInsets.all(10),
                                                      child: Loading(),
                                                    )
                                                  : Container()
                                            ],
                                          );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
