// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/rich_text_format.dart';

class RichTextView extends StatefulWidget {
  final String content;
  final bool? isPreView;
  const RichTextView({required this.content, this.isPreView, super.key});

  @override
  State<RichTextView> createState() => _RichTextViewState();
}

PhotoViewController photoViewController = PhotoViewController();

class _RichTextViewState extends State<RichTextView> with SingleTickerProviderStateMixin {
  Future<void> imageView(String imgUrl, String imgType) {
    double value = 1;
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

                      value = photoViewController.scale ?? 1;
                      if (value < 1) {
                        double t = photoViewController.scale ?? 1;
                        timer = Timer.periodic(const Duration(microseconds: 5), (timer) {
                          setState(() {
                            if (t < 1) {
                              t += 0.005;
                              photoViewController.scale = t;
                              print(t);
                            } else {
                              photoViewController.scale = 1;
                              timer.cancel();
                            }
                          });
                        });
                      } else if (value < 2.5) {
                        double t = photoViewController.scale ?? 1;
                        timer = Timer.periodic(const Duration(microseconds: 5), (timer) {
                          setState(() {
                            if (t < 2.5) {
                              t += 0.005;
                              photoViewController.scale = t;
                              print(t);
                            } else {
                              photoViewController.scale = 3;
                              timer.cancel();
                            }
                          });
                        });
                      } else {
                        double t = photoViewController.scale ?? 1;
                        timer = Timer.periodic(const Duration(microseconds: 5), (timer) {
                          setState(() {
                            if (t >= 1) {
                              t -= 0.005;
                              photoViewController.scale = t;
                              print(t);
                            } else {
                              photoViewController.scale = 1;
                              timer.cancel();
                            }
                          });
                        });
                      }
                    },
                    onDoubleTap: () {
                      print("onDoubleTap");
                      imageViewExit();
                    },
                    child: imgType == "base64"
                        ? Image.memory(
                            const Base64Decoder().convert(imgUrl),
                          )
                        : Image.network(imgUrl),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double fontSize = 18;
  @override
  Widget build(BuildContext context) {
    String choicedImg = "";
    return (widget.isPreView != true)
        //全文章
        ? HtmlWidget(
            RichTextFormat(htmlString: widget.content).editedTextToWidgetHtml(),
            textStyle: TextStyle(fontSize: fontSize),
            onTapUrl: (url) {
              print("click: $url");
              if (Platform.isAndroid) {
                final Uri _url = Uri.parse(url);
                launchUrl(_url);
              }

              return false;
            },
            customWidgetBuilder: (element) {
              if (element.localName == 'p') {
                return HtmlWidget(
                  element.innerHtml,
                  textStyle: TextStyle(fontSize: fontSize),
                  onTapUrl: (url) {
                    print("click: $url");
                    if (Platform.isAndroid) {
                      final Uri _url = Uri.parse(url);
                      launchUrl(_url);
                    }
                    return false;
                  },
                  onTapImage: (src) {
                    print("onTapImage: ${src.sources.first.url}");

                    String imgType = "network";
                    choicedImg = src.sources.first.url;
                    if (src.sources.first.url.contains('data:image/')) {
                      int startIndex = src.sources.first.url.indexOf('data:image/') + 22;
                      if (src.sources.first.url.contains('data:image/jpeg')) {
                        startIndex = src.sources.first.url.indexOf('data:image/') + 23;
                      }
                      int endIndex = src.sources.first.url.length;

                      choicedImg = src.sources.first.url.substring(startIndex, endIndex);
                      imgType = "base64";
                    }
                    print(choicedImg);
                    setState(() {
                      choicedImg = choicedImg;
                    });
                    imageView(choicedImg, imgType);
                  },
                );
              }
            },
            onTapImage: (src) {
              print("onTapImage: ${src.sources.first.url}");

              String imgType = "network";
              choicedImg = src.sources.first.url;
              if (src.sources.first.url.contains('data:image/')) {
                int startIndex = src.sources.first.url.indexOf('data:image/') + 22;
                if (src.sources.first.url.contains('data:image/jpeg')) {
                  startIndex = src.sources.first.url.indexOf('data:image/') + 23;
                }
                int endIndex = src.sources.first.url.length;

                choicedImg = src.sources.first.url.substring(startIndex, endIndex);
                imgType = "base64";
              }
              print(choicedImg);
              setState(() {
                choicedImg = choicedImg;
              });
              imageView(choicedImg, imgType);
            },
          )
        : Builder(builder: (context) {
            //プレビュー文章の画面
            bool haveImage = RichTextFormat(htmlString: widget.content).getPostPreView()["IsImage"];
            String resultString = RichTextFormat(htmlString: widget.content).getPostPreView()["resultString"];
            String imageType = "";
            if (haveImage) {
              if (resultString.contains('http')) {
                imageType = "network";
              } else {
                imageType = "base64";
              }
            }
            return haveImage
                ? imageType == "base64"
                    ? Image.memory(
                        const Base64Decoder().convert(resultString),
                        width: ScreenSize().width,
                        height: 150,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      )
                    : Image.network(
                        resultString,
                        width: ScreenSize().width,
                        height: 150,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      )
                : HtmlWidget(
                    resultString,
                    textStyle: TextStyle(fontSize: fontSize),
                  );
          });
  }
}
