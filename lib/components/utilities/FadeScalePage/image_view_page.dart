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
            child: Image.network(
              imgUrl,
              gaplessPlayback: true,
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
