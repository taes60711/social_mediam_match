// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/image_view_page.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../global/home_global_view_model.dart';
import '../../models/rich_text_format.dart';
import 'FadeScalePage/video_view_page.dart';

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

    Future<void> tapedURL(String url) async {
      print("click: $url");
      if (Platform.isAndroid) {
        await HomeGlobalViewModel().launcherURL(strUrl: url);
      }
    }

    return (widget.isPreView != true)
        //全文章
        ? SizedBox(
            width: ScreenSize.width,
            child: HtmlWidget(
              RichTextFormat(htmlString: widget.content).editedTextToWidgetHtml(),
              textStyle: TextStyle(fontSize: fontSize, color: AppColors.whiteColor),
              customWidgetBuilder: (element) {
                if (element.localName == 'p') {
                  Map<String, String> extractLinkAndImage(String htmlString) {
                    // 正則表達式匹配 <a> 標籤中的 href 和文本
                    final linkPattern = RegExp(r'href="([^"]+)"');
                    final textPattern = RegExp(r'>\s*(.*?)\s*<\/a>');

                    // 正則表達式匹配 <img> 標籤中的 src URL
                    final imgPattern = RegExp(r'src="([^"]+)"');

                    // 提取 <a> 標籤中的 URL 和文本
                    final linkMatch = linkPattern.firstMatch(htmlString);
                    final textMatch = textPattern.firstMatch(htmlString);

                    // 提取 <img> 標籤中的 src URL
                    final imgMatch = imgPattern.firstMatch(htmlString);

                    // 提取 URL 和文本，若無則返回空
                    String url = linkMatch?.group(1) ?? '';
                    String linkText = textMatch?.group(1) ?? '';
                    String imageUrl = imgMatch?.group(1) ?? '';

                    // 返回 URL、文本和圖片 URL
                    return {
                      'url': url,
                      'text': linkText,
                      'imageUrl': imageUrl,
                    };
                  }

                  print(element.innerHtml);

                  Map<String, String> extracted = extractLinkAndImage(element.innerHtml);
                  String url = extracted['url'] ?? '';
                  String linkText = extracted['text'] ?? '';
                  String imageUrl = extracted['imageUrl'] ?? '';
                  String plainText = element.innerHtml
                      .replaceAll('<br>', '') // 將 <br> 換成換行符號
                      .split('<a')[0] // 提取 <a> 標籤之前的文本
                      .replaceAll('&nbsp;', ' ') // 將 &nbsp; 替換為空格
                      .split('<img')[0]; // 提取 <img> 標籤之前的文本

                  if (imageUrl.isNotEmpty) {
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                    );
                  } else {
                    return RichText(
                      text: TextSpan(
                        style: TextStyle(color: AppColors.whiteColor, fontSize: fontSize),
                        children: <TextSpan>[
                          TextSpan(text: plainText),
                          TextSpan(
                            text: linkText,
                            style: TextStyle(
                              color: AppColors.blueColor,
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                if (url.isNotEmpty) {
                                  await HomeGlobalViewModel().launcherURL(strUrl: url);
                                }
                              },
                          ),
                        ],
                      ),
                    );
                  }
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
                          onTap: () async {
                            String ytUrl = "https://www.youtube.com/watch?v=$ytId";
                            await HomeGlobalViewModel().launcherURL(strUrl: ytUrl);
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
                            VideoViewPage(ytId: ytId).show(context);
                          },
                          child: Icon(
                            Icons.fullscreen,
                            color: AppColors.whiteColor,
                          ),
                        ),
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
                height: ScreenSize.fitPxWidth(190),
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
                textStyle: TextStyle(
                  fontSize: fontSize,
                  color: AppColors.greyColor,
                ),
              );
            }
            return component;
          });
  }
}
