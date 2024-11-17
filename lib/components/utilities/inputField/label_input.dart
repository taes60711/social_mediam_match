import 'package:flutter/material.dart';

import '../style/screen_size.dart';
import '../style/style_config.dart';
import 'base_input.dart';

class LabelInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? inputStyle;

  const LabelInput({
    super.key,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.inputStyle,
    required this.label,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
          ),
        ),
      ],
    );
  }
}
