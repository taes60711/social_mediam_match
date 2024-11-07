import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../style/screen_size.dart';

enum InputType {
  /// 一般輸入
  normal,

  /// 密碼輸入
  pwd,
}

/// 文字輸入區
class BaseInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final InputType type;
  final Function(bool value)? onFocusChanged;
  final bool isHidePwd;
  const BaseInputField({
    super.key,
    this.hintText,
    this.type = InputType.normal,
    required this.controller,
    this.onFocusChanged,
    this.isHidePwd = false,
  });

  @override
  State<BaseInputField> createState() => _BaseInputFieldState();
}

class _BaseInputFieldState extends State<BaseInputField> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        if (widget.onFocusChanged != null) {
          widget.onFocusChanged!(value);
        }
      },
      child: TextFormField(
        obscureText: widget.type == InputType.pwd && widget.isHidePwd,
        cursorColor: AppColors.whiteColor,
        decoration: InputDecoration(
          hintText: widget.hintText ?? "",
          hintStyle: TextStyle(
            color: AppColors.greyColor130,
            fontSize: ScreenSize.fontSize14,
          ),
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          isDense: true,
        ),
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: ScreenSize.fontSize14,
        ),
        controller: widget.controller,
      ),
    );
  }
}
