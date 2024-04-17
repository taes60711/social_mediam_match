import 'dart:developer';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

class RichTextFormat {
  String htmlString;

  RichTextFormat({
    required this.htmlString,
  });

  // ["15px", "18px", '24px', '32px', '48px']
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
            document.body?.querySelectorAll('*').forEach((e) {
              if (e.localName == "span") {
                inspect(e);
                String htmlUseStyle = "";
                String fontSize = "";
                if (e.className == "ql-size-huge") {
                  fontSize = "48px";
                } else if (e.className == "ql-size-large") {
                  fontSize = "32px";
                } else if (e.className == "ql-size-small") {
                  fontSize = "18px";
                }
                if (fontSize != "") {
                  htmlUseStyle = 'style = "${e.attributes['style']} font-size: $fontSize;"';
                } else {
                  htmlUseStyle = 'style = "${e.attributes['style']} "';
                }

                String htmlUseouterHtml = "<span $htmlUseStyle>${e.innerHtml.replaceAll(" ", "&nbsp;")}</span>";
                String nbspedString = e.outerHtml.replaceAll(" ", "&nbsp;");
                htmlString = htmlString.replaceAll(nbspedString, htmlUseouterHtml);
              } else if (e.localName == "a") {
                inspect(e);
                String htmlUseStyle = "";
                String fontSize = "";
                if (e.className == "ql-size-huge") {
                  fontSize = "48px";
                } else if (e.className == "ql-size-large") {
                  fontSize = "32px";
                } else if (e.className == "ql-size-small") {
                  fontSize = "18px";
                }
                if (fontSize != "") {
                  htmlUseStyle = 'style = "${e.attributes['style']} font-size: $fontSize;"';
                } else {
                  htmlUseStyle = 'style = "${e.attributes['style']} "';
                }

                String htmlUseHref = "href = ${e.attributes['href']}";
                String htmlUseouterHtml = "<a $htmlUseHref $htmlUseStyle>${e.innerHtml.replaceAll(" ", "_")}</a>";
                String nbspedString = e.outerHtml.replaceAll(" ", "&nbsp;");
                htmlString = htmlString.replaceAll(nbspedString, htmlUseouterHtml);
                // htmlString = htmlString.replaceAll(e.outerHtml, htmlUseouterHtml);
              }
            });

            break;
        }
      });
    }

    // print(htmlString);
    return htmlString;
  }
}
