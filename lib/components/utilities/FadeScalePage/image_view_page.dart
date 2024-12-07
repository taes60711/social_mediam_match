import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import 'package:social_mediam_match/services/image_service.dart';

class ImageViewPage extends BaseFadeScalePage {
  final String imgUrl;
  ImageViewPage({required this.imgUrl});
  PhotoViewController photoViewController = PhotoViewController();

  bool canUseScaleClosePage = false;
  Timer timer = Timer(Duration.zero, () {});

  @override
  Future<void> initState(WidgetRef ref) async {
    canUseScaleClosePage = true;
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      child: Stack(
        alignment: Alignment.center,
        children: [
          PhotoView.customChild(
            onScaleEnd: (context, details, controllerValue) {
              if (controllerValue.scale! < 1) {
                photoViewController.scale = 1;
                Future.delayed(const Duration(milliseconds: 300)).then(
                  (value) => canUseScaleClosePage = true,
                );
              } else if (photoViewController.scale == 1 &&
                  canUseScaleClosePage &&
                  details.pointerCount == 0 &&
                  details.velocity.pixelsPerSecond.dy.abs() > 800) {
                closePage();
              } else if (controllerValue.scale! > 1) {
                canUseScaleClosePage = false;
              }
            },
            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
            controller: photoViewController,
            child: GestureDetector(
              onDoubleTap: () {
                if (photoViewController.scale! > 1) {
                  photoViewController.scale = 1;
                } else {
                  photoViewController.scale = 2;
                }
              },
              child: Image.network(
                imgUrl,
                gaplessPlayback: true,
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: BaseTopBar(
              backFunc: () => closePage(),
            ),
          ),
          Positioned(
            bottom: ScreenSize.fitPxWidth(40),
            child: SizedBox(
              width: ScreenSize.width,
              child: Row(
                children: [
                  const Expanded(
                    child: SizedBox(width: 1),
                  ),
                  Expanded(
                    child: iconBtnWidget(
                      onPress: () {
                        ///　画像シェアする
                        ImageService().shareImage(imgUrl);
                      },
                      icon: FontAwesomeIcons.arrowUpFromBracket,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(20)),
                      alignment: Alignment.centerRight,
                      child: iconBtnWidget(
                        onPress: () {
                          ///　画像ダウンロードする
                          ImageService().saveImageToLocal(imgUrl);
                        },
                        icon: FontAwesomeIcons.download,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconBtnWidget({required IconData icon, required Function onPress}) {
    return MainBtn(
      onPress: () {
        onPress();
      },
      child: Container(
        width: ScreenSize.fitPxWidth(40),
        height: ScreenSize.fitPxWidth(40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ScreenSize.fitPxWidth(40),
          ),
          color: AppColors.greyColor54,
        ),
        child: Icon(
          icon,
          size: ScreenSize.fitPxWidth(20),
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}


  // Future<void> imageView(String imgUrl) {
  //   double value = 1;
  //   double zoomSpeed = 0.01 * ScreenSize.height / ScreenSize.width;
  //   if (Platform.isAndroid || Platform.isIOS) {
  //     zoomSpeed = 0.01;
  //   }
  //   Timer timer = Timer(Duration.zero, () {});

  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       void imageViewExit() {
  //         if (timer.isActive) {
  //           timer.cancel();
  //         }

  //         setState(() {
  //           value = 1;
  //           photoViewController.scale = value;
  //         });
  //         RouteOptions.pop();
  //       }

  //       return Scaffold(
  //         backgroundColor: Colors.black,
  //         body: Column(
  //           children: [
  //             Align(
  //               alignment: Alignment.topLeft,
  //               child: Padding(
  //                 padding: const EdgeInsets.all(15),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     imageViewExit();
  //                   },
  //                   child: const Icon(
  //                     Icons.arrow_back_ios,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               child: PhotoView.customChild(
  //                 controller: photoViewController,
  //                 backgroundDecoration: const BoxDecoration(color: Colors.transparent),
  //                 child: GestureDetector(
  //                     onTapDown: (details) {
  //                       print("onTapDown");
  //                       void zoomFunc({required double zoomChangeValue, required double resizeValue, required String type}) {
  //                         timer = Timer.periodic(const Duration(microseconds: 5), (timer) {
  //                           setState(() {
  //                             bool isEnd = false;
  //                             switch (type) {
  //                               case "less":
  //                                 if (zoomChangeValue < resizeValue) {
  //                                   zoomChangeValue += zoomSpeed;
  //                                 } else {
  //                                   isEnd = true;
  //                                 }
  //                                 break;
  //                               case "greater":
  //                                 if (zoomChangeValue >= resizeValue) {
  //                                   zoomChangeValue -= zoomSpeed;
  //                                 } else {
  //                                   isEnd = true;
  //                                 }
  //                                 break;
  //                             }

  //                             if (isEnd) {
  //                               photoViewController.scale = resizeValue;
  //                               timer.cancel();
  //                             } else {
  //                               photoViewController.scale = zoomChangeValue;
  //                               print(zoomChangeValue);
  //                             }
  //                           });
  //                         });
  //                       }

  //                       value = photoViewController.scale ?? 1;
  //                       double zoomChangeValue = photoViewController.scale ?? 1;
  //                       if (value < 1) {
  //                         zoomFunc(zoomChangeValue: zoomChangeValue, resizeValue: 1, type: "less");
  //                       } else if (value < 2.5) {
  //                         zoomFunc(zoomChangeValue: zoomChangeValue, resizeValue: 2.5, type: "less");
  //                       } else {
  //                         zoomFunc(zoomChangeValue: zoomChangeValue, resizeValue: 1, type: "greater");
  //                       }
  //                     },
  //                     onDoubleTap: () {
  //                       print("onDoubleTap");
  //                       imageViewExit();
  //                     },
  //                     child: Image.network(
  //                       imgUrl,
  //                       gaplessPlayback: true,
  //                     )),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }