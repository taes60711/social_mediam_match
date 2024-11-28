import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:uuid/uuid.dart';

import '../components/utilities/style/screen_size.dart';
import '../global.dart';
import '../services/image_service.dart';

class RichTextFormat {
  String? htmlString;
  RichTextFormat({
    this.htmlString,
  });

  // ["15px", "18px", '24px', '32px', '48px']
  Map<String, String> fontSizeMap = {
    "ql-size-huge": "48px",
    "ql-size-large": "32px",
    "ql-size-small": "15px",
  };

  Future<String> sendPostImgFormat() async {
    String _htmlString = htmlString ?? "";

    /// 圖片編輯的時候有*.8寬度 所以在整形的時候 要去除掉該處理
    _htmlString = _htmlString.replaceAll(" width=\"${ScreenSize.width * 0.8}\"", "");

    var node = html.parse(_htmlString).body;

    if (node!.nodeType == Node.ELEMENT_NODE) {
      var elements = node.querySelectorAll('*');
      for (var element in elements) {
        switch (element.localName) {
          case "p":
            var document = html.parse(element.innerHtml);

            await Future.forEach(document.body?.querySelectorAll('*') ?? [], (e) async {
              if (e.localName == 'img') {
                if (e.outerHtml.contains("base64,")) {
                  String resultString = _getImage(e.outerHtml);

                  String uid = const Uuid().v1();
                  if (await ImageService().imageIsExist(resultString) != "-1") {
                    uid = await ImageService().imageIsExist(resultString);
                  } else {
                    await ImageService().saveImg(uid, resultString);
                  }

                  String imgStringToHttp = '<img src="http://\$ip:\$port/images/$uid">';
                  _htmlString = _htmlString.replaceAll(e.outerHtml, imgStringToHttp);
                }
              }
            });
            break;
        }
      }
    }
    return _htmlString;
  }

  ///MARK:顯示用html
  String editedTextToWidgetHtml() {
    String _htmlString = mappingIPAndPort(htmlString ?? "");
    var node = html.parse(_htmlString).body;

    if (node!.nodeType == Node.ELEMENT_NODE) {
      var elements = node.querySelectorAll('*');
      elements.asMap().forEach((index, element) {
        switch (element.localName) {
          case "p":
            var document = html.parse(element.innerHtml);
            if (!element.innerHtml.contains("img") && !element.innerHtml.contains("iframe")) {
              // inspect(element);
              String pwithSpanString = element.innerHtml.replaceAll(" ", "&nbsp;");
              _htmlString = _htmlString.replaceAll(element.innerHtml, pwithSpanString);
            }
            document.body?.querySelectorAll('*').forEach(
              (e) {
                if (e.localName == "span" || e.localName == "a") {
                  // inspect(e);
                  String htmlUseStyle = 'style="${e.attributes['style']} "';
                  String fontSize = fontSizeMap[e.className] ?? "";

                  if (fontSize != "") {
                    htmlUseStyle = 'style="${e.attributes['style']} font-size:$fontSize;"';
                  }

                  String htmlUseouterHtml = "";
                  switch (e.localName) {
                    case "span":
                      htmlUseouterHtml = "<span $htmlUseStyle>${e.innerHtml.replaceAll(" ", "&nbsp;")}</span>";
                      break;
                    case "a":
                      String htmlUseHref = "href=${e.attributes['href']}";
                      htmlUseouterHtml = "<a $htmlUseHref $htmlUseStyle>${e.innerHtml.replaceAll(" ", "&nbsp;")}</a>";
                      break;
                  }

                  String nbspedString = e.outerHtml.replaceAll(" ", "&nbsp;");
                  _htmlString = _htmlString.replaceAll(nbspedString, htmlUseouterHtml);
                }
              },
            );

            break;
        }
      });
    }

    return _htmlString;
  }

  ///MARK:編輯用Html
  Future<String> widgetToEditorHtml(String htmlString) async {
    String _htmlString = mappingIPAndPort(htmlString);

    var node = html.parse(_htmlString).body;
    if (node!.nodeType == Node.ELEMENT_NODE) {
      var allElements = node.querySelectorAll('*');

      await Future.forEach(allElements, (element) async {
        switch (element.localName) {
          case "p":
            var document = html.parse(element.innerHtml);
            if (!element.innerHtml.contains("img") && !element.innerHtml.contains("iframe")) {
              String pwithSpanString = element.innerHtml.replaceAll(" ", "&nbsp;");
              _htmlString = _htmlString.replaceAll(element.innerHtml, pwithSpanString);
            }
            if (element.innerHtml.contains("http://$ip:$port/images/")) {
              String imgURL = _getImage(element.innerHtml);
              String imgUId = imgURL.substring('http://$ip:$port/images/'.length);
              String base64Str = await ImageService().getBase64Img(imgUId);
              String base64ImgHtmlStr = element.innerHtml.replaceAll(imgURL, "data:image/jpeg;base64,$base64Str");
              _htmlString = _htmlString.replaceAll(mappingIPAndPort(element.innerHtml), base64ImgHtmlStr);
            }
            document.body?.querySelectorAll('*').forEach(
              (e) {
                if (e.localName == "span" || e.localName == "a") {
                  String htmlUseStyle = '';
                  if (e.className != "") {
                    htmlUseStyle += 'class="${e.className}" ';
                  }
                  if (e.attributes['style'] != null) {
                    htmlUseStyle += 'style="${e.attributes['style']}"';
                  }
                  String htmlUseouterHtml = "";
                  switch (e.localName) {
                    case "span":
                      htmlUseouterHtml = "<span $htmlUseStyle>${e.innerHtml.replaceAll(" ", "&nbsp;")}</span>";
                      break;
                    case "a":
                      String htmlUseHref = "href=${e.attributes['href']}";
                      htmlUseouterHtml = "<a $htmlUseHref $htmlUseStyle>${e.innerHtml.replaceAll(" ", "&nbsp;")}</a>";
                      break;
                  }

                  String nbspedString = e.outerHtml.replaceAll(" ", "&nbsp;");
                  _htmlString = _htmlString.replaceAll(nbspedString, htmlUseouterHtml);
                }
              },
            );
            break;
        }
      });
    }
    print("_htmlString $_htmlString");
    return _htmlString;
  }

  ///MARK:取得預覽圖片或影片的圖片
  Map<String, dynamic> getPostPreView() {
    String _htmlString = mappingIPAndPort(htmlString ?? "");
    var node = html.parse(_htmlString).body;
    String resultString = "";
    bool isImage = false;

    if (_htmlString.length >= 100) {
      resultString = _htmlString.substring(0, 100);
    } else {
      resultString = _htmlString;
    }

    if (node!.nodeType == Node.ELEMENT_NODE) {
      var allElements = node.querySelectorAll('*');

      allElements.forEach((element) {
        if (!isImage) {
          if (element.innerHtml.contains("img")) {
            isImage = true;
            resultString = _getImage(element.innerHtml);
          } else if (element.localName == "iframe") {
            String ytId = RichTextFormat().getYtvideoID(element.outerHtml);
            isImage = true;
            resultString = "https://img.youtube.com/vi/$ytId/hqdefault.jpg";
          }
        }
      });
    }

    return {
      "IsImage": isImage,
      "resultString": resultString,
    };
  }

  String _getImage(String htmlString) {
    int startIndex = -1;

    if (htmlString.contains('src="data:image/')) {
      startIndex = htmlString.indexOf('src="data:image/') + 27;
      if (htmlString.contains('src="data:image/jpeg')) {
        startIndex = htmlString.indexOf('src="data:image/') + 28;
      }
    } else if (htmlString.contains('src="')) {
      startIndex = htmlString.indexOf('src="') + 5;
    }

    if (startIndex != -1) {
      int endIndex = htmlString.indexOf('"', startIndex);
      if (endIndex != -1) {
        return htmlString.substring(startIndex, endIndex);
      }
    }
    return '';
  }

  String mappingIPAndPort(String htmlString) {
    String changedHtmlString = htmlString.replaceAll('\$ip', ip);
    changedHtmlString = changedHtmlString.replaceAll('\$port', port);
    return changedHtmlString;
  }

  String getYtvideoID(String url) {
    int start = 0;

    if (url.contains('/shorts/')) {
      start = url.indexOf('/shorts/') + '/shorts/'.length;
    } else if (url.contains('/youtu.be/')) {
      start = url.indexOf('/youtu.be/') + '/youtu.be/'.length;
    } else if (url.contains('src=')) {
      start = url.indexOf('src=') + 'src="https://www.youtube.com/embed/'.length;
    } else {
      start = url.indexOf('?v=') + '?v='.length;
    }
    int end = 0;
    if (url.contains('&list')) {
      end = url.indexOf('&list');
    } else if (url.contains('?si')) {
      end = url.indexOf('?si');
    } else if (url.contains('src=')) {
      end = url.indexOf('">');
    } else {
      end = url.length;
    }

    String tmpId = url.substring(start, end);
    return tmpId;
  }
}
