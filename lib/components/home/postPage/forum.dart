import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_page_by_new.dart';
import 'package:social_mediam_match/components/home/postPage/post_page_by_type.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import 'post_page.dart';

class Forum extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  const Forum({super.key, required this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    PostState postState = context.read<PostState>();
    GlobalKey<ScaffoldState> forumGlobalKey = context.select((PostState value) => value.forumGlobalKey);
    List<String> boradList = ["協槓", "技術", "網頁", "韌體", "AI"];
    int selectedboardIndex = context.select((PostState value) => value.selectedboardIndex);

    return Scaffold(
      key: forumGlobalKey,
      endDrawer: ChangeNotifierProvider(
        create: (_) => PostState(),
        child: PostPageByType(
          userData: userData,
          gotoFriendPage: gotoFriendPage,
          type: selectedboardIndex,
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                items: [
                  Container(
                    color: Colors.blue,
                  ),
                  Container(
                    color: Colors.deepPurple,
                  ),
                ],
                options: CarouselOptions(
                  height: 70,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {},
                ),
              ),
            ],
          ),
          Expanded(
            child: DefaultTabController(
                length: 3,
                child: Scaffold(
                    appBar: TabBar(
                      tabs: [
                        SizedBox(
                          height: 25,
                          child: Tab(text: '人氣'),
                        ),
                        SizedBox(
                          height: 25,
                          child: Tab(text: '最新'),
                        ),
                        SizedBox(
                          height: 25,
                          child: Tab(text: '看板'),
                        ),
                      ],
                      isScrollable: true,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 1.0, color: normalBgColor),
                        insets: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      labelPadding: EdgeInsets.only(top: 5, left: 10, right: 10),
                      labelColor: normalBgColor2,
                    ),
                    body: TabBarView(
                      children: [
                        ChangeNotifierProvider(
                          create: (_) => PostState(),
                          child: PostPage(
                            userData: userData,
                            gotoFriendPage: gotoFriendPage,
                          ),
                        ),
                        ChangeNotifierProvider(
                          create: (_) => PostState(),
                          child: PostPageByNew(
                            userData: userData,
                            gotoFriendPage: gotoFriendPage,
                          ),
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: boradList.length,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          postState.boardOnChange(index);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          color: Colors.cyan,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  color: const Color.fromARGB(255, 116, 136, 153),
                                                ),
                                              ),
                                              Text("${boradList[index]}"),
                                            ],
                                          ),
                                        ),
                                      ));
                                }),
                              ),
                            )
                          ],
                        ),
                      ],
                    ))),
          ),
        ],
      ),
    );
  }
}
