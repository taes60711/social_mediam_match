import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:social_mediam_match/services/image_service.dart';

class ImageViewPage extends BaseFadeScalePage {
  final String imgUrl;
  ImageViewPage({required this.imgUrl});
  PhotoViewController photoViewController = PhotoViewController();

  bool canUseScaleClosePage = false;
  bool isZooming = true;
  bool isMaskAppear = true;
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
      type: PageType.window,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// 画像ビュー
          PhotoView.customChild(
            onTapUp: (context, details, controllerValue) {
              isMaskAppear = !isMaskAppear;
              render();
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
            backgroundDecoration: BoxDecoration(color: AppColors.transparent),
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
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                placeholder: (context, url) {
                  return const Loading();
                },
              ),
            ),
          ),

          /// topBar
          Positioned(
            top: 0,
            child: AnimatedOpacity(
              opacity: isMaskAppear ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.only(top: ScreenSize.fitPxWidth(35)),
                color: Colors.black.withOpacity(.6),
                child: BaseTopBar(
                  backFunc: () => closeView(),
                ),
              ),
            ),
          ),

          /// bottomBar
          Positioned(
            bottom: 0,
            child: AnimatedOpacity(
              opacity: isMaskAppear ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                height: ScreenSize.fitPxWidth(90),
                padding: EdgeInsets.only(top: ScreenSize.fitPxWidth(10)),
                width: ScreenSize.width,
                color: Colors.black.withOpacity(.6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        alignment: Alignment.topRight,
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
        color: AppColors.transparent,
        child: Icon(
          icon,
          size: ScreenSize.fitPxWidth(20),
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
