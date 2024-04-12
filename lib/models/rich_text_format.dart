import 'dart:convert';
import 'dart:developer';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

class RichTextFormat {
  String? jsonString;
  List<dynamic>? jsonList;

  RichTextFormat({
    this.jsonString,
    this.jsonList,
  });

  String toHtmlString() {
    print("jsonToHtmlString:");
    List<dynamic> mapJsonList = [];
    if (jsonString != null) {
      mapJsonList = jsonDecode(jsonString!);
    } else {
      mapJsonList = jsonList!;
    }

    String htmlString = "";
    for (int i = 0; i < mapJsonList.length; i++) {
      dynamic insertData = mapJsonList[i]['insert'];
      dynamic insertDataAttributes = mapJsonList[i];
      String attributes = "";
      String space = ' ';
      if (insertDataAttributes.containsKey('attributes')) {
        dynamic tmpattributes = insertDataAttributes['attributes'];
        if (tmpattributes.containsKey('style')) {
          attributes = insertDataAttributes['attributes']['style'];
        }
      }
      if (mapJsonList[i]['insert'] is String) {
        if (insertData.substring(insertData.length - 2, insertData.length) == r'\n') {
          htmlString += "<p style='$attributes'>${insertData.substring(0, insertData.length - 2)}</p>";
        } else {
          htmlString += "<p style='$attributes'>$insertData</p>";
        }
      } else {
        if (insertData.containsKey('image')) {
          String imgUrl = insertData['image'];
          String insertHtml = 'src=$imgUrl$space';
          if (attributes != "") {
            insertHtml += 'style="$attributes"';
          }
          htmlString += '<img $insertHtml></img>';
        } else if (insertData.containsKey('linkTitle')) {
          String link = insertDataAttributes['attributes']['link'];
          String linkText = insertData['linkTitle'];
          String insertHtml = 'href=$link$space';
          if (attributes != "") {
            insertHtml += 'style="$attributes"';
          }
          htmlString += '<a $insertHtml>$linkText</a>';
        } else if (insertData.containsKey('video')) {
          String videoUrl = insertData['video'];
          String insertHtml = 'src=$videoUrl$space';
          if (attributes != "") {
            insertHtml += 'style="$attributes"';
          }
          htmlString += '<iframe $insertHtml></iframe>';
        }
      }
    }

    parseNodeToJsonList(html.parse(htmlString).body);

    print("formatted String : ${htmlString}");
    return htmlString;
  }

  // 解析HTML节点到Quill JSON格式
  dynamic parseNodeToJsonList(Element? node) {
    List<Map<String, dynamic>> jsonMap = [];

    if (node!.nodeType == Node.ELEMENT_NODE) {
      var elements = node.querySelectorAll('*');
      elements.asMap().forEach((index, element) {
        if (element.nodeType == Node.ELEMENT_NODE) {
          print('Local name of element: ${element.localName}');

          switch (element.localName) {
            case "p":
              jsonMap.add({'"insert"': '"${element.innerHtml}\\n"'});
              break;
            case "img":
              jsonMap.add({
                '"insert"': {'"image"': '"${element.attributes['src']}"'},
              });
              break;
            case "a":
              inspect(element);
              if (element.attributes['style'] != null) {
                jsonMap.add({
                  '"insert"': {'"linkTitle"': '"${element.innerHtml}"'},
                  '"attributes"': {'"link"': '"${element.attributes['href']}"', '"style"': '"${element.attributes['style']}"'}
                });
              } else {
                jsonMap.add({
                  '"insert"': {'"linkTitle"': '"${element.innerHtml}"'},
                  '"attributes"': {'"link"': '"${element.attributes['href']}"'}
                });
              }

              break;
            case "iframe":
              jsonMap.add({
                '"insert"': {'"video"': '"${element.attributes['src']}"'},
              });
              break;
          }
          if (element.attributes['style'] != null && element.localName != 'a') {
            jsonMap[index]["attributes"] = {'"style"': '"${element.attributes['style']}"'};
          }
        }
      });
      print("jsonMap: $jsonMap");
      return jsonMap;
    }
  }
}
