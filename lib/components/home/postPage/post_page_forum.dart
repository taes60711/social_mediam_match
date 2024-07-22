import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/home/postPage/post_page_by_new.dart';
import 'package:social_mediam_match/components/utilities/stateful_wrapper.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/components/utilities/user_icon.dart';
import 'package:social_mediam_match/provider/post/post_provider.dart';
import 'package:social_mediam_match/provider/post/post_view_model.dart';
import '../../../models/post_model.dart';
import '../../utilities/apiListView/base_api_list_provider.dart';
import '../../utilities/endDrawers/post_board_end_drawer.dart';
import '../../utilities/endDrawers/post_comment_end_drawer.dart';
import '../../utilities/endDrawers/post_page_by_text_filter_end_drawer.dart';
import '../../utilities/endDrawers/user_detail_end_drawer.dart';
import 'post_page_by_viewer.dart';

class PostPageForum extends StatelessWidget {
  const PostPageForum({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () async {
        await PostViewModel(postContext: context).getTopPost().then((_) async {
          await PostViewModel(postContext: context).getAllPostBoard();
        });
      },
      child: Scaffold(
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
                Builder(builder: (context) {
                  List<PostModel> topPosts = context.select((PostProvider value) => value.topPost);

                  return topPosts.isEmpty
                      ? Container()
                      : CarouselSlider(
                          items: topPosts.map((e) {
                            return GestureDetector(
                              onTap: () {
                                PostViewModel(postContext: context).postDetailInit(choicedPost: e);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                width: ScreenSize.width,
                                color: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.title),
                                    Container(
                                      width: ScreenSize.width,
                                      height: 0.3,
                                      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text("作成者:", style: TextStyle(fontSize: 12, color: normalBgColor2)),
                                              const SizedBox(width: 5),
                                              UserIcon(
                                                iconSize: 20,
                                                image: e.postUserInfo.image,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(e.postUserInfo.name != "" ? e.postUserInfo.name ?? "" : e.postUserInfo.email,
                                                  style: TextStyle(fontSize: 12, color: normalBgColor2)),
                                            ],
                                          ),
                                        ),
                                        const Text("進入", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                        const Icon(FontAwesomeIcons.rightToBracket, size: 12, color: Colors.grey)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 55,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            autoPlay: true,
                          ),
                        );
                }),
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
                      body: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TabBarView(
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
                            postBoradList(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            postBoardEndDrawer(),
            postPageBytextFilterEndDrawer(),
            postDetailEndDrawer(),
            userDetailEndDrawer(),
          ],
        ),
      ),
    );
  }

  Widget postBoradList(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: context.select((PostProvider value) => value.allPostBoards).length,
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
                          Text(context.read<PostProvider>().allPostBoards[index].name),
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
