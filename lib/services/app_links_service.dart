import 'package:app_links/app_links.dart';
import 'package:social_mediam_match/components/utilities/toast.dart';

class AppLinkService {
  final appLinks = AppLinks();

  Future<void> init() async {
    try {
      Uri? uri = await appLinks.getInitialLink();
      print("AppLinks Init");
      if (uri != null) {
        print("appLinks $uri");

        Map<String, String>? mappedData = parseUrl("${uri}");
        Toast().showCenter(msg: "type: ${mappedData!["type"]} id: ${mappedData["content"]}");
      }

      applinkListen();
    } catch (e) {
      print(e);
    }
  }

  void applinkListen() {
    appLinks.uriLinkStream.listen((event) {
      Map<String, String>? mappedData = parseUrl("${event}");
      Toast().showCenter(msg: "type: ${mappedData!["type"]} id: ${mappedData["content"]}");
    });
  }

  void applinkStop() {}

  Map<String, String>? parseUrl(String url) {
    final regExp = RegExp(r'^https://universal-link\.directsense\.tw/(\w+)/(\d+)$');
    final match = regExp.firstMatch(url);

    if (match != null) {
      final type = match.group(1);
      final id = match.group(2);
      return {'type': type!, 'content': id!};
    }
    return null;
  }
}
