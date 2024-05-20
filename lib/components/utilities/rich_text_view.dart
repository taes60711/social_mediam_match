// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/rich_text_format.dart';

class RichTextView extends StatefulWidget {
  final String content;
  final bool? isPreView;
  final double? fontSize;
  const RichTextView({required this.content, this.isPreView, this.fontSize, super.key});

  @override
  State<RichTextView> createState() => _RichTextViewState();
}

PhotoViewController photoViewController = PhotoViewController();

class _RichTextViewState extends State<RichTextView> with SingleTickerProviderStateMixin {
  Future<void> imageView(String imgUrl) {
    double value = 1;
    double zoomSpeed = 0.01 * ScreenSize().height / ScreenSize().width;
    Timer timer = Timer(Duration.zero, () {});

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        void imageViewExit() {
          if (timer.isActive) {
            timer.cancel();
          }

          setState(() {
            value = 1;
            photoViewController.scale = value;
          });
          Navigator.of(context).pop();
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      imageViewExit();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PhotoView.customChild(
                  controller: photoViewController,
                  backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                  child: GestureDetector(
                      onTapDown: (details) {
                        print("onTapDown");
                        void zoomFunc({required double zoomChangeValue, required double resizeValue, required String type}) {
                          timer = Timer.periodic(const Duration(microseconds: 5), (timer) {
                            setState(() {
                              bool isEnd = false;
                              switch (type) {
                                case "less":
                                  if (zoomChangeValue < resizeValue) {
                                    zoomChangeValue += zoomSpeed;
                                  } else {
                                    isEnd = true;
                                  }
                                  break;
                                case "greater":
                                  if (zoomChangeValue >= resizeValue) {
                                    zoomChangeValue -= zoomSpeed;
                                  } else {
                                    isEnd = true;
                                  }
                                  break;
                              }

                              if (isEnd) {
                                photoViewController.scale = resizeValue;
                                timer.cancel();
                              } else {
                                photoViewController.scale = zoomChangeValue;
                                print(zoomChangeValue);
                              }
                            });
                          });
                        }

                        value = photoViewController.scale ?? 1;
                        double zoomChangeValue = photoViewController.scale ?? 1;
                        if (value < 1) {
                          zoomFunc(zoomChangeValue: zoomChangeValue, resizeValue: 1, type: "less");
                        } else if (value < 2.5) {
                          zoomFunc(zoomChangeValue: zoomChangeValue, resizeValue: 2.5, type: "less");
                        } else {
                          zoomFunc(zoomChangeValue: zoomChangeValue, resizeValue: 1, type: "greater");
                        }
                      },
                      onDoubleTap: () {
                        print("onDoubleTap");
                        imageViewExit();
                      },
                      child: Image.network(
                        imgUrl,
                        gaplessPlayback: true,
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = widget.fontSize ?? 18;
    late List<YoutubePlayerController> ytController = [];
    int index = 0;

    String choicedImg = "";

    void tapedURL(String url) {
      print("click: $url");
      if (Platform.isAndroid) {
        final Uri _url = Uri.parse(url);
        launchUrl(_url);
      }
    }

    return (widget.isPreView != true)
        //全文章
        ? HtmlWidget(
            RichTextFormat(htmlString: widget.content).editedTextToWidgetHtml(),
            textStyle: TextStyle(fontSize: fontSize),
            onTapUrl: (url) {
              tapedURL(url);
              return false;
            },
            customWidgetBuilder: (element) {
              if (element.localName == 'p') {
                return HtmlWidget(
                  element.innerHtml,
                  textStyle: TextStyle(fontSize: fontSize),
                  onTapUrl: (url) {
                    tapedURL(url);
                    return false;
                  },
                  onTapImage: (src) {
                    print("onTapImage: ${src.sources.first.url}");
                    setState(() {
                      choicedImg = src.sources.first.url;
                    });
                    imageView(choicedImg);
                  },
                );
              } else if (element.localName == "iframe") {
                String ytId = RichTextFormat().getYtvideoID(element.outerHtml);
                index = ytController.length;

                ytController.add(
                  YoutubePlayerController(
                    initialVideoId: ytId,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                );

                return SizedBox(
                  width: ScreenSize().width,
                  child: YoutubePlayer(
                    controller: ytController[index],
                    onReady: () => {},
                  ),
                );
              }
            },
            onTapImage: (src) {
              print("onTapImage: ${src.sources.first.url}");
              setState(() {
                choicedImg = src.sources.first.url;
              });
              imageView(choicedImg);
            },
          )
        : Builder(builder: (context) {
            //プレビュー文章の画面
            bool haveImage = RichTextFormat(htmlString: widget.content).getPostPreView()["IsImage"];
            String resultString = RichTextFormat(htmlString: widget.content).getPostPreView()["resultString"];

            Widget component;
            if (haveImage) {
              component = Image.network(
                resultString,
                width: ScreenSize().width,
                height: 150,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              );
            } else {
              component = HtmlWidget(
                resultString,
                textStyle: TextStyle(fontSize: fontSize),
              );
            }
            return component;
          });
  }
}
