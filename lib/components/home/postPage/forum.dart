import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_page_by_new.dart';
import 'package:social_mediam_match/components/home/postPage/post_page_by_textfilter.dart';
import 'package:social_mediam_match/components/home/postPage/post_page_by_type.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import '../../utilities/custom_end_drawer.dart';
import 'post_page.dart';

class Forum extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  final VoidCallback gotoCoursePage;
  const Forum({super.key, required this.userData, required this.gotoFriendPage, required this.gotoCoursePage});

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
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                useSafeArea: false,
                barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
                builder: (BuildContext context) {
                  return CustomEndDrawer(
                    child: Dismissible(
                      direction: DismissDirection.startToEnd,
                      resizeDuration: const Duration(milliseconds: 1),
                      onDismissed: (_) => Navigator.of(context).pop(),
                      key: const Key('key'),
                      child: ChangeNotifierProvider(
                        create: (_) => PostState(),
                        child: PostPageByTextFilter(
                          userData: userData,
                          gotoFriendPage: gotoFriendPage,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5),
              ),
              width: ScreenSize().width,
              height: 36,
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.search, color: Colors.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text("Search By title", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  )
                ],
              ),
            ),
          ),
          Stack(
            children: [
              CarouselSlider(
                items: [
                  GestureDetector(
                    onTap: () {
                      gotoCoursePage();
                    },
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      gotoFriendPage();
                    },
                    child: Container(
                      color: Colors.deepPurple,
                    ),
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
                      tabs: const [
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
                        insets: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      labelPadding: const EdgeInsets.only(top: 5, left: 10, right: 10),
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
                                          padding: const EdgeInsets.all(8),
                                          color: const Color.fromARGB(255, 236, 157, 120),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(right: 8.0),
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: Color.fromARGB(255, 213, 226, 236),
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
