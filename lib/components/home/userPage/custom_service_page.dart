import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/custom_button.dart';
import 'package:social_mediam_match/components/utilities/label_input.dart';

import '../../utilities/background_widget.dart';
import '../../utilities/basic_top_bar.dart';

class CustomServicePage extends StatefulWidget {
  const CustomServicePage({super.key});

  @override
  State<CustomServicePage> createState() => _CustomServicePageState();
}

class _CustomServicePageState extends State<CustomServicePage> {
  TextEditingController emailInput = TextEditingController();
  TextEditingController titleInput = TextEditingController();
  TextEditingController conentInput = TextEditingController();
  String contentStr = "";
  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Column(
        children: [
          const BaseTopBar(
            title: "問題回報",
          ),
          LabelInput(
            title: "標題",
            textController: titleInput,
            isRequired: true,
          ),
          LabelInput(
            title: "Email",
            textController: emailInput,
            isRequired: true,
          ),
          MultiLabelInput(
            title: "回報內容",
            textController: conentInput,
            isRequired: true,
            displayText: contentStr,
            maxdisplayLine: 15,
            multiOnChange: (String value) {
              contentStr = value;
              setState(() {});
            },
          ),
          const SizedBox(height: 10),
          MainBtn(
              title: "送出",
              innerPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              onPress: () {
                print("send title ${titleInput.text} email ${emailInput.text} content ${conentInput.text}");
              })
        ],
      ),
    );
  }
}
