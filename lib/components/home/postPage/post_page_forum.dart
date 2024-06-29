import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_page_by_new.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../../models/post_model.dart';
import '../../../pageManager/enum/bottom_bar_path.dart';
import '../../../pageManager/setting/bottom_bar_controller_provider.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/endDrawers/post_board_end_drawer.dart';
import '../../utilities/endDrawers/post_comment_end_drawer.dart';
import '../../utilities/endDrawers/post_page_by_text_filter_end_drawer.dart';
import 'post_page_by_viewer.dart';

class PostPageForum extends StatelessWidget {
  const PostPageForum({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  openPostPageBytextFilterEndDrawer(context: context);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: ScreenSize.width,
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
                          context.read<BottomBarControllerProvider>().bottomBarPageChange(BottomBarPath.course);
                        },
                        child: Container(
                          color: Colors.blue,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<BottomBarControllerProvider>().bottomBarPageChange(BottomBarPath.chatRoom);
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
                        MultiProvider(
                          providers: [
                            ChangeNotifierProvider(create: (_) => BaseAPIListProvider<PostModel>()),
                          ],
                          child: const PostPageByViewer(),
                        ),
                        MultiProvider(
                          providers: [
                            ChangeNotifierProvider(create: (_) => BaseAPIListProvider<PostModel>()),
                          ],
                          child: const PostPageByNew(),
                        ),
                        postBoradList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          postBoardEndDrawer(),
          postPageBytextFilterEndDrawer(),
          postDetailEndDrawer(),
        ],
      ),
    );
  }

  Widget postBoradList() {
    List<String> boradList = ["協槓", "技術", "網頁", "韌體", "AI"];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: boradList.length,
            itemBuilder: ((context, index) {
              return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () {
                      openPostBoardEndDrawer(context: context, boardType: index);
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
                              color: const Color.fromARGB(255, 213, 226, 236),
                            ),
                          ),
                          Text(boradList[index]),
                        ],
                      ),
                    ),
                  ));
            }),
          ),
        )
      ],
    );
  }
}
