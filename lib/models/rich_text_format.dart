import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

class RichTextFormat {
  String htmlString;

  RichTextFormat({
    required this.htmlString,
  });

  // ["15px", "18px", '24px', '32px', '48px']
  Map<String, String> fontSizeMap = {
    "ql-size-huge": "48px",
    "ql-size-large": "32px",
    "ql-size-small": "15px",
  };

  String editedTextToWidgetHtml() {
    var node = html.parse(htmlString).body;

    if (node!.nodeType == Node.ELEMENT_NODE) {
      var elements = node.querySelectorAll('*');
      elements.asMap().forEach((index, element) {
        switch (element.localName) {
          case "p":
            var document = html.parse(element.innerHtml);
            if (!element.innerHtml.contains("img") && !element.innerHtml.contains("iframe")) {
              // inspect(element);
              String pwithSpanString = element.innerHtml.replaceAll(" ", "&nbsp;");
              htmlString = htmlString.replaceAll(element.innerHtml, pwithSpanString);
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
                  htmlString = htmlString.replaceAll(nbspedString, htmlUseouterHtml);
                }
              },
            );

            break;
        }
      });
    }

    // print(htmlString);
    // WidgetToEditorHtml(htmlString);

    return htmlString;
  }

  String widgetToEditorHtml(String htmlString) {
    dynamic getKeyByValue(Map<dynamic, dynamic> map, dynamic value) {
      for (var entry in map.entries) {
        if (entry.value == value) {
          return entry.key;
        }
      }
      return null;
    }

    // print(htmlString);
    var node = html.parse(htmlString).body;
    if (node!.nodeType == Node.ELEMENT_NODE) {
      var allElements = node.querySelectorAll('*');

      allElements.forEach((element) {
        switch (element.localName) {
          case "p":
            var document = html.parse(element.innerHtml);
            if (!element.innerHtml.contains("img") && !element.innerHtml.contains("iframe")) {
              String pwithSpanString = element.innerHtml.replaceAll(" ", "&nbsp;");
              htmlString = htmlString.replaceAll(element.innerHtml, pwithSpanString);
            }
            document.body?.querySelectorAll('*').forEach(
              (e) {
                if (e.localName == "span" || e.localName == "a") {
                  // inspect(e);
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
                  htmlString = htmlString.replaceAll(nbspedString, htmlUseouterHtml);
                }
              },
            );

            break;
        }
      });
    }

    // print(htmlString);
    return htmlString;
  }

  Map<String, dynamic> getPostPreView() {
    var node = html.parse(htmlString).body;
    String resultString = "";
    bool isImage = false;

    if (htmlString.length >= 100) {
      resultString = htmlString.substring(0, 100);
    } else {
      resultString = htmlString;
    }

    if (node!.nodeType == Node.ELEMENT_NODE) {
      var allElements = node.querySelectorAll('*');

      String getImageUrl(String htmlString) {
        int startIndex = htmlString.indexOf('src="');
        if (startIndex != -1) {
          int endIndex = htmlString.indexOf('"', startIndex + 5);
          if (endIndex != -1) {
            return htmlString.substring(startIndex + 5, endIndex);
          }
        }
        return '';
      }

      allElements.forEach((element) {
        if (element.innerHtml.contains("img")) {
          isImage = true;
          resultString = getImageUrl(element.innerHtml);
        }
      });
    }

    return {
      "IsImage": isImage,
      "resultString": resultString,
    };
  }
}
