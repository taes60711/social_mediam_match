import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../global.dart';

class ImageService {
  String url = "http://$ip:$port/images";

  Future<String> getBase64Img(String image) async {
    String uid = "-1";
    String searchUrl = '$url/$image';
    final uri = Uri.parse(searchUrl);

    try {
      var response = await http.get(uri);
      if (response.statusCode != 404) {
        String base64String = base64Encode(response.bodyBytes);
        uid = base64String;
      }
    } catch (e) {
      print(e);
    }

    return uid;
  }

  Future<String> imageIsExist(String image) async {
    String uid = "-1";
    String searchUrl = '$url/checkImage';
    Map<String, String> headers = {'content-type': 'application/json'};
    final uri = Uri.parse(searchUrl);

    try {
      String body = jsonEncode({"image": image});

      var response = await http.put(uri, headers: headers, body: body);
      if (response.statusCode != 404) {
        print(response.body);
        uid = response.body;
      }
    } catch (e) {
      print(e);
    }

    return uid;
  }

  Future<bool> saveImage(String id, String image) async {
    bool isSucess = false;
    String searchUrl = '$url/saveImg';
    Map<String, String> headers = {'content-type': 'application/json'};

    final uri = Uri.parse(searchUrl);
    try {
      String body = jsonEncode({"id": id, "image": image});

      var response = await http.put(uri, headers: headers, body: body);
      if (response.statusCode != 404) {
        isSucess = true;
        print("saveImage sucess");
      }
    } catch (e) {
      print(e);
    }
    return isSucess;
  }
}
