// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:developer';
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

String choicedImg = "";

class _RichTextViewState extends State<RichTextView> {
  Future<void> imageView(String imgUrl) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
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
                      Navigator.of(context).pop();
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
                  backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                  child: GestureDetector(
                    onDoubleTap: () => Navigator.of(context).pop(),
                    child: Image.network(imgUrl),
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
    return (widget.isPreView != true)
        //全文章
        ? HtmlWidget(
            RichTextFormat(htmlString: widget.content).editedTextToWidgetHtml(),
            textStyle: TextStyle(fontSize: fontSize),
            onTapUrl: (url) {
              print("click: $url");
              final Uri _url = Uri.parse(url);
              launchUrl(_url);
              return false;
            },
            customWidgetBuilder: (element) {
              if (element.localName == 'p') {
                return HtmlWidget(
                  element.innerHtml,
                  textStyle: TextStyle(fontSize: fontSize),
                  onTapUrl: (url) {
                    print("click: $url");
                    final Uri _url = Uri.parse(url);
                    launchUrl(_url);
                    return false;
                  },
                  onTapImage: (src) {
                    inspect(src);
                    setState(() {
                      choicedImg = src.sources.first.url;
                    });
                    imageView(choicedImg);
                  },
                );
              }
            },
            onTapImage: (src) {
              inspect(src);
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
            return haveImage
                ? Image.network(
                    resultString,
                    width: ScreenSize().width,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : HtmlWidget(
                    resultString,
                    textStyle: TextStyle(fontSize: fontSize),
                  );
          });
  }
}
