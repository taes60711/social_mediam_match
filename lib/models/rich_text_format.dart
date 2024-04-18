import 'dart:developer';
import 'package:flutter/material.dart';
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
                  inspect(e);
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
                      String htmlUseHref = "href = ${e.attributes['href']}";
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

    print(htmlString);
    WidgetToEditorHtml(htmlString);

    return htmlString;
  }

  String WidgetToEditorHtml(String htmlString) {
    dynamic getKeyByValue(Map<dynamic, dynamic> map, dynamic value) {
      for (var entry in map.entries) {
        if (entry.value == value) {
          return entry.key;
        }
      }
      return null;
    }

    var node = html.parse(htmlString).body;
    if (node!.nodeType == Node.ELEMENT_NODE) {
      var elements = node.querySelectorAll('span');
      elements.forEach((element) {
        if (element.attributes['style']!.contains("font-size")) {
          String str = element.attributes['style']!;
          int fontSizeStartIndex = str.indexOf("font-size") + "font-size:".length;
          int fontSizeEndIndex = fontSizeStartIndex + 4;
          String subedString = str.substring(fontSizeStartIndex, fontSizeEndIndex);

          String key = getKeyByValue(fontSizeMap, subedString);
          print("subedString : $subedString : key : $key");
          String editorUseHtml = element.outerHtml.replaceAll("font-size:$subedString", key);
          print("editorUseHtml : $editorUseHtml");
          htmlString = htmlString.replaceAll(element.outerHtml, editorUseHtml);
        }
      });
    }
    print(htmlString);
    return htmlString;
  }
}
