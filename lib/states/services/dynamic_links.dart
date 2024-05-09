import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinks {
  Future<String> createLink(String refCode) async {
    final String url = "https://app.social_mediam_match?ref=$refCode";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        androidParameters: AndroidParameters(packageName: "com.example.social_mediam_match", minimumVersion: 0),
        iosParameters: IOSParameters(bundleId: "com.example.social_mediam_match", minimumVersion: "0"),
        link: Uri.parse(url),
        uriPrefix: "https://socialmediammatch.page.link");

    final FirebaseDynamicLinks link = await FirebaseDynamicLinks.instance;
    final refLink = await link.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }

  void initDynamicLink(BuildContext context) async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) {
      final Uri refLink = instanceLink.link;
      void t() {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Link'),
              content: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text("refCode : ${refLink.queryParameters['ref']}"),
                ]),
              ),
            );
          },
        );
      }

      t();

      print("${refLink.queryParameters['ref']}");
    }
  }
}
