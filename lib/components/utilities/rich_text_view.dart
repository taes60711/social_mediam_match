// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/image_view_page.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
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
  @override
  Widget build(BuildContext context) {
    double fontSize = widget.fontSize ?? ScreenSize.fontSize14;
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
        ? SizedBox(
            width: ScreenSize.width,
            child: HtmlWidget(
              RichTextFormat(htmlString: widget.content).editedTextToWidgetHtml(),
              textStyle: TextStyle(fontSize: fontSize, color: AppColors.whiteColor),
              onTapUrl: (url) {
                tapedURL(url);
                return false;
              },
              customWidgetBuilder: (element) {
                if (element.localName == 'p') {
                  return HtmlWidget(
                    element.innerHtml,
                    textStyle: TextStyle(fontSize: fontSize, color: AppColors.whiteColor),
                    onTapUrl: (url) {
                      tapedURL(url);
                      return false;
                    },
                    onTapImage: (src) {
                      print("onTapImage: ${src.sources.first.url}");
                      setState(() {
                        choicedImg = src.sources.first.url;
                      });
                      ImageViewPage(imgUrl: choicedImg).show(context);
                    },
                  );
                } else if (element.localName == "iframe") {
                  String ytId = RichTextFormat().getYtvideoID(element.outerHtml);
                  index = ytController.length;

                  ytController.add(
                    YoutubePlayerController(
                      initialVideoId: ytId,
                      flags: const YoutubePlayerFlags(
                        disableDragSeek: true,
                        autoPlay: false,
                        mute: false,
                      ),
                    ),
                  );

                  return SizedBox(
                    width: ScreenSize.width,
                    child: YoutubePlayer(
                      controller: ytController[index],
                      onReady: () => {},
                      bottomActions: [
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                        RemainingDuration(),
                        PlaybackSpeedButton(
                          icon: Icon(
                            FontAwesomeIcons.gear,
                            size: ScreenSize.fontSize18,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final Uri _url = Uri.parse("https://www.youtube.com/watch?v=$ytId");
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
                        )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
              onTapImage: (src) {
                print("onTapImage: ${src.sources.first.url}");
                setState(() {
                  choicedImg = src.sources.first.url;
                });
                ImageViewPage(imgUrl: choicedImg).show(context);
              },
            ),
          )
        : Builder(builder: (context) {
            //プレビュー文章の画面
            bool haveImage = RichTextFormat(htmlString: widget.content).getPostPreView()["IsImage"];
            String resultString = RichTextFormat(htmlString: widget.content).getPostPreView()["resultString"];

            Widget component;
            if (haveImage) {
              component = CachedNetworkImage(
                imageUrl: resultString,
                width: ScreenSize.width,
                height: ScreenSize.fitPxWidth(120),
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: AppColors.greyColor98,
                    highlightColor: AppColors.greyColor98.withOpacity(.7),
                    child: Container(
                      width: ScreenSize.width,
                      height: ScreenSize.fitPxWidth(120),
                      decoration: BoxDecoration(color: AppColors.greyColor98),
                    ),
                  );
                },
              );
            } else {
              component = HtmlWidget(
                resultString,
                textStyle: TextStyle(fontSize: fontSize, color: Colors.grey),
              );
            }
            return component;
          });
  }
}
