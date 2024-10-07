import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../../pagemanager/setting/route_controller.dart';

Widget _titleText({required bool isInputRequired, required String title}) {
  Widget titleWidget = Padding(
    padding: const EdgeInsets.only(left: 5, bottom: 5),
    child: Text(title),
  );
  if (isInputRequired) {
    titleWidget = Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red),
          ),
          TextSpan(text: title),
        ],
      ),
    );
  }
  return titleWidget;
}

Widget _textField(TextEditingController textController, {required bool isMulti}) {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.grey, width: 0.0),
  );

  InputDecoration inputDecoration = InputDecoration(
    filled: isMulti,
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    contentPadding: const EdgeInsets.all(8),
    border: const OutlineInputBorder(),
  );

  return isMulti
      ? TextField(
          minLines: 3,
          maxLines: 6,
          cursorColor: normalBgColor2,
          controller: textController,
          decoration: inputDecoration,
          keyboardType: TextInputType.multiline,
        )
      : TextField(
          cursorColor: normalBgColor2,
          controller: textController,
          decoration: inputDecoration,
        );
}

class MultiLabelInput extends StatelessWidget {
  final TextEditingController textController;
  final String displayText;
  final Function(String) multiOnChange;
  final String title;
  final bool? isRequired;
  final EdgeInsetsGeometry padding;

  const MultiLabelInput({
    super.key,
    required this.title,
    required this.textController,
    required this.displayText,
    required this.multiOnChange,
    this.isRequired,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
  });

  @override
  Widget build(BuildContext context) {
    bool isInputRequired = isRequired ?? false;
    return Padding(
      padding: padding,
      child: SizedBox(
        width: ScreenSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleText(isInputRequired: isInputRequired, title: title),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  useSafeArea: true,
                  builder: (builder) {
                    return DraggableScrollableSheet(
                      expand: false,
                      minChildSize: 0.8,
                      initialChildSize: 1,
                      maxChildSize: 1,
                      builder: (context, scrollController) {
                        return Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                _topBar(
                                  title: title,
                                  context: context,
                                  textController: textController,
                                  multiOnChange: multiOnChange,
                                ),
                                const SizedBox(height: 15),
                                _textField(textController, isMulti: true),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: _multiDisplayWidget(displayText: displayText),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _multiDisplayWidget({required String displayText}) {
  return Container(
    width: ScreenSize.width,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Colors.grey.withOpacity(0.4),
      ),
      color: Colors.grey.withOpacity(0.1),
    ),
    child: Text(
      displayText,
      maxLines: 6,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _topBar(
    {required String title,
    required BuildContext context,
    required TextEditingController textController,
    required Function(String) multiOnChange}) {
  return BaseTopBar(
    title: title,
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    backFunc: () => RouteOptions.pop(),
    rightWidget: GestureDetector(
      onTap: () {
        multiOnChange(textController.text);
        RouteOptions.pop();
      },
      child: Container(
        color: Colors.transparent,
        width: 35,
        height: 35,
        child: const Text("保存"),
      ),
    ),
  );
}

class LabelInput extends StatelessWidget {
  final String title;
  final double? inputHeight;
  final TextEditingController textController;
  final bool? isRequired;
  final EdgeInsetsGeometry padding;
  const LabelInput({
    super.key,
    required this.title,
    this.inputHeight,
    this.isRequired,
    required this.textController,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
  });

  @override
  Widget build(BuildContext context) {
    bool isInputRequired = isRequired ?? false;
    double viewInputHeight = inputHeight ?? 36;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(isInputRequired: isInputRequired, title: title),
          SizedBox(
            width: ScreenSize.width,
            height: viewInputHeight,
            child: _textField(textController, isMulti: false),
          ),
        ],
      ),
    );
  }
}

class TextInput extends StatefulWidget {
  final TextEditingController textController;
  final Function(String)? onChanged;
  const TextInput({
    super.key,
    required this.textController,
    this.onChanged,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool bIsEdit = false;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    setState(() {
      focusNode.unfocus();
      bIsEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey, width: 0.0),
    );

    InputDecoration inputDecoration = InputDecoration(
      enabledBorder: InputBorder.none,
      focusedBorder: outlineInputBorder,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      border: const OutlineInputBorder(),
    );

    return bIsEdit
        ? Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  autofocus: bIsEdit,
                  decoration: inputDecoration,
                  controller: widget.textController,
                  onChanged: widget.onChanged,
                ),
              ),
              const SizedBox(width: 10),
            ],
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                if (bIsEdit) {
                  focusNode.unfocus();
                  bIsEdit = false;
                } else {
                  focusNode.requestFocus();
                  bIsEdit = true;
                }
              });
            },
            child: Text(
              widget.textController.text,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          );
  }
}
