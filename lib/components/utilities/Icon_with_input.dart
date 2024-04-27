import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

class IconWithInput extends StatelessWidget {
  final IconData icon;
  final TextEditingController inputController;
  final String? hintText;
  final double? size;

  const IconWithInput({super.key, required this.icon, required this.inputController, this.hintText, this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              icon,
              size: size ?? 36,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: size ?? 36,
              child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      top: size == null ? 6 : size! - 30,
                      left: 8,
                    ),
                    border: const OutlineInputBorder(),
                    hintText: hintText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleInput extends StatelessWidget {
  final String title;
  final double? inputHeight;
  final TextEditingController textController;
  final bool? isRequired;
  final bool? isMulti;
  const TitleInput(
      {super.key, required this.title, this.inputHeight, this.isRequired, this.isMulti, required this.textController});

  @override
  Widget build(BuildContext context) {
    bool isInputRequired = isRequired ?? false;
    bool isInputMulti = isMulti ?? false;
    double viewInputHeight = inputHeight ?? 36;

    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isInputRequired
              ? Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(
                        text: title,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 5),
                  child: Text(title),
                ),
          isInputMulti
              ? SizedBox(
                  width: ScreenSize().width,
                  child: TextField(
                    minLines: 3,
                    maxLines: 6,
                    cursorColor: normalBgColor2,
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "",
                      filled: true,
                      enabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      contentPadding: const EdgeInsets.all(8),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                )
              : SizedBox(
                  width: ScreenSize().width,
                  height: viewInputHeight,
                  child: TextField(
                    cursorColor: normalBgColor2,
                    controller: textController,
                    decoration: InputDecoration(
                      enabledBorder: outlineInputBorder,
                      focusedBorder: outlineInputBorder,
                      contentPadding: const EdgeInsets.all(8),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
