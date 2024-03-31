import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/user_model.dart';
import '../../../states/post_state.dart';
import 'post_page.dart';

class Forum extends StatelessWidget {
  final LoginUser userData;
  final VoidCallback gotoFriendPage;
  const Forum({super.key, required this.userData, required this.gotoFriendPage});

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> forumGlobalKey = context.select((PostState value) => value.forumGlobalKey);
    List<String> boradList = ["協槓", "技術", "網頁", "韌體", "AI"];

    return Scaffold(
      key: forumGlobalKey,
      endDrawer: ChangeNotifierProvider(
        create: (_) => PostState(),
        child: PostPage(
          userData: userData,
          gotoFriendPage: gotoFriendPage,
        ),
      ),
      body: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: const TabBar(
                tabs: [
                  Tab(text: '人氣'),
                  Tab(text: '最新'),
                  Tab(text: '看板'),
                ],
                isScrollable: true,
                labelColor: Colors.black,
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
                  Container(
                    width: 100,
                    height: 100,
                    child: Text("最新文章"),
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
                                    forumGlobalKey.currentState!.openEndDrawer();
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
    );
  }
}
