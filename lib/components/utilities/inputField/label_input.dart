import 'package:flutter/material.dart';

import '../style/screen_size.dart';
import '../style/app_colors.dart';
import 'base_input.dart';

class LabelInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? inputStyle;
  final Function(String value)? onChanged;
  final InputType type;
  final List<String>? errMsg;
  final bool readOnly;
  const LabelInput({
    super.key,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.inputStyle,
    required this.label,
    this.onChanged,
    this.type = InputType.normal,
    this.errMsg,
    this.readOnly = false,
  });

  @override
  State<LabelInput> createState() => _LabelInputState();
}

class _LabelInputState extends State<LabelInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: ScreenSize.fontSize18,
          ),
        ),
        SizedBox(height: ScreenSize.fitPxWidth(5)),
        widget.readOnly
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: BaseInputField(
                  inputStyle: widget.inputStyle ?? TextStyle(color: AppColors.greyColor98, fontSize: ScreenSize.fontSize18),
                  controller: widget.controller,
                  readOnly: widget.readOnly,
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyColor98),
                  borderRadius: BorderRadius.circular(
                    ScreenSize.fitPxWidth(8),
                  ),
                ),
                child: BaseInputField(
                  hintText: widget.hintText,
                  hintStyle: widget.hintStyle ?? TextStyle(color: AppColors.greyColor98, fontSize: ScreenSize.fontSize18),
                  inputStyle: widget.inputStyle ?? TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
                  controller: widget.controller,
                  type: widget.type,
                  maxLines: 1,
                  minLines: 1,
                  readOnly: widget.readOnly,
                  onChanged: (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
                ),
              ),
        SizedBox(height: ScreenSize.fitPxWidth(5)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(5)),
          child: widget.errMsg == null
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.errMsg!
                      .map(
                        (e) => Visibility(
                          visible: e != "",
                          child: Text(
                            e,
                            style: TextStyle(color: AppColors.redColor),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}
