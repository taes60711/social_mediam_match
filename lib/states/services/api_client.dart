// ignore_for_file: avoid_print
import 'dart:convert';

import '../../global.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String _ip;
  final Function? _onRequestFailed;
  ApiClient({String? overrideIp, Function? onRequestFailed})
      : _ip = overrideIp ?? "$ip:$port",
        _onRequestFailed = onRequestFailed;

  ///MARK: API Get Func
  Future<String> apiGet(
    String url, {
    Map<String, dynamic>? paramters,
  }) async {
    final uri = Uri.parse("http://$_ip$url").replace(queryParameters: paramters);
    print("Get API  Url : $url");
    Response response = await http.get(uri);

    try {
      if (response.statusCode != 200) {
        throw ArgumentError("${response.statusCode}");
      }
    } catch (e) {
      _onError(e);
      return "null";
    }

    return utf8.decode(response.bodyBytes);
  }

  ///MARK: API Push Func
  Future<String> apiPush(
    String url, {
    required Map<String, dynamic> body,
  }) async {
    final uri = Uri.parse("http://$_ip$url");
    Map<String, String> headers = {'content-type': 'application/json'};
    print("Push API Url : $url body : ${jsonEncode(body)}");
    Response response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    try {
      if (response.statusCode != 200) {
        throw ArgumentError("${response.statusCode}");
      }
    } catch (e) {
      _onError(e);
      return "null";
    }

    return "Success";
  }

  void _onError(dynamic errorMessage) {
    if (_onRequestFailed != null) {
      _onRequestFailed();
    }

    print("Error Message : $errorMessage");
  }

  //MARK: Response Handle
  ///APIclient取得したデータチェック：Get場合はデータモデルに加工する、Push場合は成功がどうか確認する
  Future<dynamic> handleResponse<T>(String responseData, {dynamic Function(dynamic json)? model}) async {
    dynamic result;
    try {
      if (responseData == "null") {
        throw ArgumentError("service error");
      }
      if (model != null) {
        result = model(json.decode(responseData));
      }
    } catch (e) {
      print(e);
    }
    return result;
  }
}
