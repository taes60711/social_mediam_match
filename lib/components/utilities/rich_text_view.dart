import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/rich_text_format.dart';

class RichTextView extends StatefulWidget {
  String content;
  RichTextView({required this.content, super.key});

  @override
  State<RichTextView> createState() => _RichTextViewState();
}

class _RichTextViewState extends State<RichTextView> {
  Future<void> imageView(String imgUrl) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onPanDown: (_) {},
          child: Dismissible(
            direction: DismissDirection.vertical,
            onDismissed: (_) => Navigator.of(context).pop(),
            key: const Key('key'),
            child: Scaffold(
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
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PhotoView(
                      imageProvider: NetworkImage(imgUrl),
                      backgroundDecoration: BoxDecoration(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String choicedImg = "";
  String s =
      '<p><span style="color: rgb(255, 235, 59);">51121</span>   23   13.<span class="ql-size-large" style="background-color: rgb(0, 150, 136);">    Hh</span></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/uE_T_t6s_Go"></iframe><p><span class="ql-size-large" style="background-color: rgb(0, 150, 136);">ffgh</span></p><p><img src="https://images.chinatimes.com/newsphoto/2024-04-03/1024/20240403005728.jpg"></p><p><a href="https://forum.gamer.com.tw" rel="noopener noreferrer" target="_blank" style="color: rgb(63, 81, 181);">Launcher URL</a></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/ceJhXI6LwjE"></iframe><p><br></p>';
  //'<p>Vfdvvd. 此      刺激<span style="color: rgb(0, 188, 212);">動</span></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/AbGWXUTQyuk"></iframe><p><img src="https://images.chinatimes.com/newsphoto/2024-04-03/1024/20240403005728.jpg">世<span class="ql-size-huge" style="color: rgb(33, 150, 243);"> 界</span><a href="https://www.youtube.com/watch?v=AbGWXUTQyuk&amp;list=RDAbGWXUTQyuk&amp;start_radio=1" rel="noopener noreferrer" target="_blank"> 級</a></p>';
  //'<p>Vfdvvd. 此 刺        激<span style="color: rgb(0, 188, 212);">動</span></p><iframe class="ql-video" frameborder="0" allowfullscreen="true" src="https://www.youtube.com/embed/AbGWXUTQyuk"></iframe><p>蘇遲遲是辭職</p><p>是以<br></p><p><img src="https://images.chinatimes.com/newsphoto/2024-04-03/1024/20240403005728.jpg">世<span class="ql-size-huge" style="color: rgb(33, 150, 243);"> 界</span><a href="https://www.youtube.com/watch?v=AbGWXUTQyuk&amp;list=RDAbGWXUTQyuk&amp;start_radio=1" rel="noopener noreferrer" target="_blank"> </a>TI餓我<a href="https://www.youtube.com/watch?v=o2xjnjmStys" rel="noopener noreferrer" target="_blank">啊</a><br></p><p>就是<br></p>';

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      RichTextFormat(htmlString: widget.content).editedTextToWidgetHtml(),
      textStyle: TextStyle(fontSize: 18),
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
            textStyle: TextStyle(fontSize: 18),
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
    );
  }
}
