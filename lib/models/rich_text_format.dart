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

      if (mapJsonList[i]['insert'] is String) {
        if (insertData.substring(insertData.length - 2, insertData.length) == r'\n') {
          htmlString += "<p>${insertData.substring(0, insertData.length - 2)}</p>";
        } else {
          htmlString += "<p>$insertData</p>";
        }
      } else {
        dynamic insertDataAttributes = mapJsonList[i];
        String attributes = "";
        if (insertDataAttributes.containsKey('attributes')) {
          attributes = insertDataAttributes['attributes']['style'];
        }
        if (insertData.containsKey('image')) {
          String imgUrl = insertData['image'];
          htmlString += '<img src=$imgUrl style="$attributes"></img>';
        } else if (insertData.containsKey('url')) {
          String link = insertData['url'];
          htmlString += '<a href=$link style="$attributes">Launch URL</a>';
        } else if (insertData.containsKey('video')) {
          String videoUrl = insertData['video'];
          htmlString += ' <iframe src=$videoUrl style="$attributes"></iframe>';
        }
      }
    }

    // 转换HTML节点到Quill JSON格式
    parseNodeToJsonList(html.parse(htmlString).body);

    print("formatted String : ${htmlString}");
    return htmlString;
  }

  // 解析HTML节点到Quill JSON格式
  dynamic parseNodeToJsonList(Element? node) {
    List<Map<String, dynamic>> jsonMap = [];

    if (node!.nodeType == Node.ELEMENT_NODE) {
      var elements = node.querySelectorAll('*');
      elements.forEach((element) {
        if (element.nodeType == Node.ELEMENT_NODE) {
          inspect(element);
          print('Local name of element: ${element.localName}');
          switch (element.localName) {
            case "p":
              jsonMap.add({'"insert"': '"${element.innerHtml}"'});
              break;
            case "img":
              jsonMap.add({
                '"insert"': {'"image"': '"${element.attributes['src']}"'},
                '"attributes"': {'"style"': '"${element.attributes['style']}"'}
              });
              break;
            case "a":
              jsonMap.add({
                '"insert"': {'"url"': '"${element.attributes['href']}"'},
                '"attributes"': {'"style"': '"${element.attributes['style']}"'}
              });
              break;
            case "iframe":
              jsonMap.add({
                '"insert"': {'"video"': '"${element.attributes['src']}"'},
                '"attributes"': {'"style"': '"${element.attributes['style']}"'}
              });
              break;
          }
        }
      });
      print(jsonMap);
      return jsonMap;
    }
  }
}
