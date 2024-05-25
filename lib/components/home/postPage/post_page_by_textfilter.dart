import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/CustomBouncingScrollPhysics.dart';
import 'package:social_mediam_match/components/home/postPage/post_body.dart';

import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import '../../utilities/loading.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class PostPageByTextFilter extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  const PostPageByTextFilter({super.key, required this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    TextEditingController textFilterInput = context.select((PostState value) => value.textFilterInput);
    List<PostModel> postData = context.select((PostState value) => value.postData);
    PostState postState = context.read();
    GlobalKey<ScaffoldState> globalKey = context.select((PostState value) => value.globalKey);

    bool isCanLoading = context.select((PostState value) => value.isCanLoading);
    bool isDataAddLoding = context.select((PostState value) => value.isDataAddLoding);
    bool isReLoading = context.select((PostState value) => value.isReLoading);
    double startScrollPosition = context.select((PostState value) => value.startScrollPosition);
    ScrollController scrollController = ScrollController();
    Widget searchBar = Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 4, top: 2, bottom: 2),
            width: ScreenSize().width,
            height: 36,
            child: TextField(
              cursorColor: normalBgColor2,
              controller: textFilterInput,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                Future.delayed(Duration(milliseconds: 200)).then(
                    (value) async => await postState.getPostByTextFilter(inputedText: textFilterInput.text, searchType: "First"));
              },
              decoration: InputDecoration(
                hintText: "Search By title",
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                fillColor: Colors.grey.withOpacity(0.3),
                focusColor: Colors.grey.withOpacity(0.3),
                filled: true,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                iconColor: Colors.grey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(8),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            width: 50,
            height: 36,
            child: Text("Cancel"),
          ),
        )
      ],
    );

    return Scaffold(
      body: Column(
        children: [
          searchBar,
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
                      postState.getPostByTextFilter(inputedText: textFilterInput.text, searchType: "AddData");
                    } else if (isReLoading && isCanLoading) {
                      postState.getPostByTextFilter(inputedText: textFilterInput.text, searchType: "Reload");
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
    );
  }
}
