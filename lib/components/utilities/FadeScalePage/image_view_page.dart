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
  bool isZooming = true;
  Timer timer = Timer(Duration.zero, () {});

  @override
  Future<void> initState(WidgetRef ref) async {
    await Future.delayed(const Duration(milliseconds: 300));
    canUseScaleClosePage = true;
    isZooming = false;
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      child: Stack(
        alignment: Alignment.center,
        children: [
          PhotoView.customChild(
            onTapUp: (context, details, controllerValue) {
              if (controllerValue.scale! > 1) {
                /// 當大小為大於１時單擊變回１的大小
                if (!isZooming) {
                  zoomImageFunc(zoomType: "toMin");
                }
              } else if (photoViewController.scale! <= 1 && canUseScaleClosePage) {
                /// 當大小為１時單擊關閉圖片視窗
                closeView();
              }
            },
            onScaleEnd: (context, details, controllerValue) {
              if (controllerValue.scale! < 1 && details.pointerCount != 0) {
                /// 當大小縮小至１&以下且雙指的情況自動變回１
                scaleToNormal();
              } else if (photoViewController.scale! <= 1 &&
                  details.pointerCount == 0 &&
                  canUseScaleClosePage &&
                  details.velocity.pixelsPerSecond.dy.abs() > 800) {
                /// 上下滑動關閉圖片視窗
                closeView();
              } else if (controllerValue.scale! > 1) {
                canUseScaleClosePage = false;
              }
            },
            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
            controller: photoViewController,
            child: GestureDetector(
              onDoubleTap: () {
                if (!isZooming) {
                  if (photoViewController.scale! >= 2) {
                    /// 當圖片大小大於２時 縮小回１
                    zoomImageFunc(zoomType: "toMin");
                  } else {
                    zoomImageFunc(zoomType: "toLarge");
                  }
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
              backFunc: () => closeView(),
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

  void zoomImageFunc({required String zoomType}) {
    double photoScale = photoViewController.scale!;
    double zoomvalue = -1;
    isZooming = true;
    if (zoomType == "toLarge") {
      zoomvalue = 0.01;
    } else if (zoomType == "toMin") {
      zoomvalue = -0.01;
    }

    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      bool condition = false;
      if (zoomType == "toLarge") {
        condition = photoScale <= 2;
      } else if (zoomType == "toMin") {
        condition = photoScale >= 1;
      }
      if (isZooming) {
        if (condition) {
          photoScale += zoomvalue;
          photoViewController.scale = photoScale;
        } else {
          timer.cancel();
          if (zoomType == "toMin") {
            scaleToNormal();
          }
          Future.delayed(const Duration(milliseconds: 300)).then((value) => isZooming = false);
        }
      }

      render();
    });
  }

  void scaleToNormal() {
    photoViewController.scale = 1;
    Future.delayed(const Duration(milliseconds: 300)).then((value) => canUseScaleClosePage = true);
  }

  void closeView() {
    if (timer.isActive) {
      photoViewController.scale = 1;
      timer.cancel();
    }
    closePage();
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
