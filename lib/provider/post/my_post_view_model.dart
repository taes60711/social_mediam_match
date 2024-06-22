import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/pageManager/setting/route_controller.dart';

import '../../components/utilities/style/screen_size.dart';
import '../../components/utilities/style/style_config.dart';

class MyPostViewModel {
  BuildContext context;
  MyPostViewModel({required this.context});
  void showOptionBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return DraggableScrollableSheet(
              expand: false,
              minChildSize: 0.25,
              initialChildSize: 0.3,
              maxChildSize: 0.3,
              builder: (context, scrollController) {
                // List<PostOption> bSheetFuncs = bottomSheetFuncs ?? [];
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
                        )
                        // Expanded(
                        //   child: SingleChildScrollView(
                        //     physics:const ClampingScrollPhysics(),
                        //     child: Column(
                        //       children: bSheetFuncs
                        //           .map((e) => Padding(
                        //                 padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                        //                 child: GestureDetector(
                        //                   onTap: () {
                        //                     e.buttonFunc();
                        //                   },
                        //                   child: Container(
                        //                     width: ScreenSize.width,
                        //                     height: 45,
                        //                     decoration:
                        //                         BoxDecoration(color: normalBgColor2, borderRadius: BorderRadius.circular(10)),
                        //                     child: Center(
                        //                       child: SizedBox(
                        //                         width: 100,
                        //                         child: Row(
                        //                           children: [
                        //                             Icon(
                        //                               e.icon,
                        //                               color: normalTextColor,
                        //                               size: 25,
                        //                             ),
                        //                             const SizedBox(width: 5),
                        //                             SizedBox(
                        //                               width: 70,
                        //                               child: Center(
                        //                                 child: Text(
                        //                                   e.funcText,
                        //                                   style: TextStyle(color: normalTextColor),
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ))
                        //           .toList(),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ));
              });
        });
  }
}
