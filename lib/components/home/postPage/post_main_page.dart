import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../global/global_view_model.dart';
import '../../utilities/BottomSheets/base_bottom_sheet.dart';
import '../../utilities/background_widget.dart';
import '../../utilities/endDrawers/custom_end_drawer.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class PostMainPage extends ConsumerStatefulWidget {
  const PostMainPage({super.key});

  @override
  ConsumerState<PostMainPage> createState() => _PostMainPageState();
}

bool topPostExpansion = false;
double listScrollStartPos = 0;
bool isScrollUp = false;

class _PostMainPageState extends ConsumerState<PostMainPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Stack(
        children: [
          listenListView(
            context,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "123",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "123",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "123",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hot!",
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          "打造高效工作環境的五個關鍵策略asdasdasdasasdsa",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 1),
                          width: ScreenSize.width,
                          height: .5,
                          color: Colors.grey,
                        ),
                        Row(
                          children: [
                            Text(
                              "作成者:",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                BaseBottomSheet().show(
                                  context,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Modal BottomSheet',
                                        style: TextStyle(color: AppColors.whiteColor),
                                      ),
                                      ElevatedButton(
                                        child: const Text('Close BottomSheet'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "asdasdsa",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: ScreenSize.width,
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 80,
                    color: const Color.fromARGB(255, 37, 37, 37),
                  ),
                  Container(
                    width: ScreenSize.width,
                    margin: EdgeInsets.only(bottom: 10),
                    height: 80,
                    color: Color.fromARGB(255, 37, 37, 37),
                  ),
                  Container(
                    width: ScreenSize.width,
                    margin: EdgeInsets.only(bottom: 10),
                    height: 80,
                    color: Color.fromARGB(255, 37, 37, 37),
                  ),
                  Container(
                    width: ScreenSize.width,
                    margin: EdgeInsets.only(bottom: 10),
                    height: 150,
                    color: Color.fromARGB(255, 37, 37, 37),
                  ),
                  Container(
                    width: ScreenSize.width,
                    margin: EdgeInsets.only(bottom: 10),
                    height: 100,
                    color: Color.fromARGB(255, 37, 37, 37),
                  ),
                  Container(
                    width: ScreenSize.width,
                    margin: EdgeInsets.only(bottom: 10),
                    height: 100,
                    color: Color.fromARGB(255, 37, 37, 37),
                  ),
                  Container(
                    width: ScreenSize.width,
                    margin: EdgeInsets.only(bottom: 10),
                    height: 100,
                    color: Color.fromARGB(255, 37, 37, 37),
                  ),
                  Container(
                    width: ScreenSize.width,
                    margin: EdgeInsets.only(bottom: 10),
                    height: 100,
                    color: Color.fromARGB(255, 37, 37, 37),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            top: ref.watch(bottomNavationBarPosProvider) != -60 ? 3 : -45,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 150),
            child: GestureDetector(
              onTap: () {
                BaseEndDrawer().show(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 58, 57, 57),
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
                    Text(
                      "搜尋",
                      style: TextStyle(
                        color: Color.fromARGB(255, 226, 226, 226),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///LisViewの状態をリスン
  Widget listenListView(BuildContext context, {required child}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        /// only listen depth list == 0
        if (scrollNotification.depth != 0) {
          return false;
        }

        if (scrollNotification is ScrollStartNotification) {
          listScrollStartPos = scrollNotification.metrics.pixels;
        }

        if (scrollNotification is ScrollUpdateNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;
          final max = scrollNotification.metrics.maxScrollExtent;
          bool isScrollingUp = scrollPosition < listScrollStartPos;
          if (!isScrollUp) {
            if (isScrollingUp) {
              GlobalViewModel().bottomBarHideStateChage(false);
              isScrollUp = true;
            }
          } else {
            if (!isScrollingUp) {
              GlobalViewModel().bottomBarHideStateChage(true);
              isScrollUp = false;
            }
          }
        }

        ///API読み込む
        if (scrollNotification is ScrollEndNotification) {
          final scrollPosition = scrollNotification.metrics.pixels;
        }
        return false;
      },
      child: child,
    );
  }
}
