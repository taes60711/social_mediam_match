import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_body.dart';
import 'package:social_mediam_match/components/utilities/Stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/models/post_model.dart';
import 'package:social_mediam_match/states/post_state.dart';
import '../../../models/user_model.dart';
import '../../utilities/loading.dart';
import '../skillExChangePage/user_detail.dart';

class PostPage extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;

  const PostPage({super.key, required this.userData, required this.gotoFriendPage});

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

    print("PostPage isFirstLoading: ${isFirstLoading}");
    return StatefulWrapper(
      onInit: () async {
        Future.delayed(Duration(milliseconds: 200)).then((value) async => await postState.getPostData(searchType: "First"));
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
              floatingActionButton: Visibility(
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
                              final scrollPosition = scrollNotification.metrics.pixels;
                              postState.getStartScrollPos(scrollPosition);
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
                            } else if (scrollNotification is ScrollEndNotification) {
                              if (isDataAddLoding && isCanLoading) {
                                postState.getPostData(searchType: "AddData");
                              } else if (isReLoading && isCanLoading) {
                                postState.getPostData(searchType: "Reload");
                              }
                            }

                            return false;
                          },
                          child: postData.isEmpty
                              ? const NoPostData()
                              : ListView.builder(
                                  controller: scrollController,
                                  itemCount: postData.length,
                                  itemBuilder: (context, index) {
                                    Widget mainBody = PostBody(
                                      postData: postData[index],
                                      postState: postState,
                                      globalKey: globalKey,
                                      userData: userData,
                                      gotoFriendPage: gotoFriendPage,
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
