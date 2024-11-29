import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:social_mediam_match/components/utilities/appBar/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';

class ImageViewPage extends BaseFadeScalePage {
  final String imgUrl;
  ImageViewPage({required this.imgUrl});
  PhotoViewController photoViewController = PhotoViewController();

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      child: Column(
        children: [
          BaseTopBar(
            backFunc: () => closePage(),
          ),
          Expanded(
            child: PhotoView.customChild(
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              child: Image.network(
                imgUrl,
                gaplessPlayback: true,
              ),
            ),
          ),
        ],
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
  //         Navigator.of(globalContext).pop();
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
