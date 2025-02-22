import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../global.dart';
import '../../../models/rich_text_format.dart';
import '../appBar/basic_top_bar.dart';
import '../common_scaffold.dart';
import '../loading.dart';
import '../main_button.dart';
import '../style/app_colors.dart';
import '../style/screen_size.dart';
import 'base_fade_scale_page.dart';

class VideoImageViewPage extends BaseFadeScalePage {
  List<String> fileUrl;
  int initIndex;
  VideoImageViewPage({required this.fileUrl, required this.initIndex});
  bool isMaskAppear = true;
  int index = 0;

  bool isInit = false;
  @override
  Future<void> initState(WidgetRef ref) async {
    index = initIndex;
    isInit = true;
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      type: PageType.window,
      child: isInit
          ? Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dy > 0) {
                      closePage();
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx < 0) {
                      if (fileUrl.length - 1 > index) {
                        index++;
                      }
                    } else {
                      if (index > 0) {
                        index--;
                      }
                    }

                    render();
                  },
                  child: Builder(
                    builder: (context) {
                      return fileUrl[index].contains("youtube")
                          ? YtVideoWidget(
                              videoUrl: fileUrl[index],
                            )
                          : ImageWidget(
                              img: fileUrl[index],
                            );
                    },
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
              ],
            )
          : Container(),
    );
  }

  void closeView() {
    closePage();
  }
}

class ImageWidget extends StatefulWidget {
  final String img;
  const ImageWidget({super.key, required this.img});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  PhotoViewController photoViewController = PhotoViewController();
  bool isZooming = true;
  Timer timer = Timer(Duration.zero, () {});
  String imgUrl = "";

  @override
  void initState() {
    startView();
    super.initState();
  }

  @override
  void dispose() {
    closeView();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    startView();

    /// 画像ビュー
    return PhotoView.customChild(
      onScaleEnd: (context, details, controllerValue) {
        if (controllerValue.scale! < 1 && details.pointerCount != 0) {
          /// 當大小縮小至１&以下且雙指的情況自動變回１
          scaleToNormal();
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
    );
  }

  Future<void> startView() async {
    if (widget.img.contains(APIHttpController.databaseDomainStr)) {
      imgUrl = RichTextFormat().mappingIPAndPort(widget.img);
    } else {
      imgUrl = widget.img;
    }

    print(imgUrl);
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 300));
    isZooming = false;
  }

  void closeView() {
    if (timer.isActive) {
      photoViewController.scale = 1;
      timer.cancel();
    }
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

      setState(() {});
    });
  }

  void scaleToNormal() {
    photoViewController.scale = 1;
  }
}

//Yt Video
class YtVideoWidget extends StatefulWidget {
  final String videoUrl;
  const YtVideoWidget({super.key, required this.videoUrl});

  @override
  State<YtVideoWidget> createState() => _YtVideoWidgetState();
}

class _YtVideoWidgetState extends State<YtVideoWidget> {
  bool init = false;
  bool isFull = false;
  String ytId = "";
  late YoutubePlayerController ytController;

  @override
  void initState() {
    super.initState();
    startView();
    setState(() {});
  }

  @override
  void dispose() {
    closeView();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return init
        ? CommonScaffold(
            child: Center(
              child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: ytController,
                  bottomActions: [
                    PlaybackSpeedButton(
                      icon: Icon(
                        FontAwesomeIcons.gear,
                        size: ScreenSize.fontSize18,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                    GestureDetector(
                      onTap: () {
                        final Uri _url = Uri.parse("https://www.youtube.com/watch?v=${ytId}");
                        launchUrl(_url);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          FontAwesomeIcons.windowRestore,
                          size: ScreenSize.fontSize18,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    MainBtn(
                      onPress: () {
                        isFull = !isFull;
                        setState(() {});
                        ();
                        ytController.toggleFullScreenMode();
                      },
                      child: Icon(
                        Icons.fullscreen,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
                builder: (context, player) {
                  return player;
                },
              ),
            ),
          )
        : Container();
  }

  void startView() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    ytId = RichTextFormat().getYtvideoID(widget.videoUrl);

    ytController = YoutubePlayerController(
      initialVideoId: ytId,
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: true,
        disableDragSeek: true,
        autoPlay: true,
        mute: false,
      ),
    );

    init = true;
  }

  void closeView() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
