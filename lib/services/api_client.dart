// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import '../../global.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../components/utilities/dialog/confirm_dialog.dart';
import '../pageManager/setting/route_controller.dart';

class ApiClient {
  final String _ip;

  ApiClient({String? overrideIp}) : _ip = overrideIp ?? "$ip:$port";

  ///MARK: API Get Func
  Future<String> apiGet(
    String url, {
    Map<String, dynamic>? paramters,
    bool needReturnPrint = false,
  }) async {
    final uri = Uri.parse("http://$_ip$url").replace(queryParameters: paramters);
    print("Get API  Url : $_ip$url");
    Response response = await http.get(uri);
    try {
      if (response.statusCode != 200) {
        throw ArgumentError("${response.statusCode}");
      }
    } catch (e) {
      _onError(e);
      return "null";
    }

    if (needReturnPrint) {
      print("return Data : ${utf8.decode(response.bodyBytes)}");
    }

    return utf8.decode(response.bodyBytes);
  }

  ///MARK: API GetBase64Img Func
  Future<String> apiGet64Img(
    String url, {
    Map<String, dynamic>? paramters,
  }) async {
    final uri = Uri.parse("http://$_ip$url").replace(queryParameters: paramters);
    print("Get API  Img Url : $url");
    Response response = await http.get(uri);

    try {
      if (response.statusCode != 200) {
        throw ArgumentError("${response.statusCode}");
      }
    } catch (e) {
      _onError(e);
      return "null";
    }

    return base64Encode(response.bodyBytes);
  }

  ///MARK: API Push Func
  Future<String> apiPush(
    String url, {
    Map<String, String> headers = const {'content-type': 'application/json'},
    required Map<String, dynamic> body,
  }) async {
    final uri = Uri.parse("http://$_ip$url");
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

    return response.body;
  }

  void _onError(dynamic errorMessage) {
    print("Error Message : $errorMessage");
  }

  //MARK: Response Handle
  ///APIclient取得したデータチェック：Get場合はデータモデルに加工する、Push場合は成功がどうか確認する
  Future<dynamic> handleResponse<T>(
    String responseData, {
    dynamic Function(Map<String, dynamic> json)? model,
    bool isList = false,
  }) async {
    dynamic result;
    try {
      if (responseData == "null") {
        throw ArgumentError("service error");
      }
      if (model != null) {
        if (isList) {
          List<dynamic> listData = json.decode(responseData);
          result = <T>[];
          for (var e in listData) {
            result.add(model(e) as T);
          }
        } else {
          dynamic data = json.decode(responseData);
          result = model(data);
        }
      }
    } catch (e) {
      print(e);
    }

    return result;
  }

  bool _isDialogShowing = false;
  void onRequestFailed({Function? onFailedFunc}) {
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      ConfirmDilaog(
          title: "警告",
          content: tr("serverErrorContent"),
          btnAmount: 1,
          conirmFunc: () {
            onFailedFunc != null ? onFailedFunc() : RouteOptions.pop();
            _isDialogShowing = false;
          }).show(globalContext);
    }
  }
}
