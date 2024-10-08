import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_mediam_match/components/utilities/label_input.dart';
import 'package:social_mediam_match/global.dart';
import 'package:social_mediam_match/services/api_client.dart';

import 'components/utilities/custom_button.dart';
import 'components/utilities/style/style_config.dart';
import 'pagemanager/setting/route_controller.dart';
import 'provider/Initial/initial_provider.dart';

///MARK: テスト用
class TestIpInputPage extends StatefulWidget {
  const TestIpInputPage({super.key});

  @override
  State<TestIpInputPage> createState() => _TestIpInputPageState();
}

class _TestIpInputPageState extends State<TestIpInputPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController ipInputController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LabelInput(isRequired: true, title: "IP", textController: ipInputController),
            ElevatedButton(
              onPressed: () {
                ip = ipInputController.text;
                setState(() {});
              },
              child: const Text("change Ip"),
            ),
            const Text("now Ip:"),
            Text(ip),
            ElevatedButton(
              onPressed: () async {
                await TestApiService().testAPI().then((isConnected) {
                  isConnected ? context.read<InitialProvider>().toFirstEnterAppPage() : _ipErr();
                });
              },
              child: const Text("Enter To App"),
            ),
          ],
        ),
      ),
    );
  }
}

void _ipErr() {
  showDialog<void>(
    context: globalContext,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(15),
          width: 180,
          height: 150,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Expanded(
                child: Text("IP錯誤"),
              ),
              TextBtn(
                title: tr("errConfirm"),
                titleColor: normalTextColor,
                btnColor: normalBgColor,
                onPress: () {
                  RouteOptions.pop();
                },
              )
            ],
          ),
        ),
      );
    },
  );
}

class TestApiService extends ApiClient {
  TestApiService() : super(overrideIp: "$ip:$port/skill");
  Future<bool> testAPI() async {
    try {
      await apiGet('/getList');
    } catch (e) {
      return false;
    }

    return true;
  }
}
