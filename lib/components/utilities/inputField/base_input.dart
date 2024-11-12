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
  final TextStyle? hintStyle;
  final TextStyle? inputStyle;
  final InputType type;
  final bool isHidePwd;
  final TextInputAction? textInputAction;
  final Function(String value)? onFieldSubmitted;

  final bool autoFocus;
  final Function(bool value)? onFocusChanged;

  final bool readOnly;
  const BaseInputField({
    super.key,
    this.hintText,
    this.hintStyle,
    this.inputStyle,
    this.type = InputType.normal,
    required this.controller,
    this.onFocusChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.isHidePwd = false,
    this.autoFocus = false,
    this.readOnly = false,
  });

  @override
  State<BaseInputField> createState() => _BaseInputFieldState();
}

class _BaseInputFieldState extends State<BaseInputField> {
  late FocusNode _focusNode;
  @override
  void initState() {
    _focusNode = FocusNode();
    if (widget.autoFocus) {
      _focusNode.requestFocus();
    }

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        if (widget.onFocusChanged != null) {
          widget.onFocusChanged!(value);
        }
      },
      child: TextFormField(
        focusNode: _focusNode,
        obscureText: widget.type == InputType.pwd && widget.isHidePwd,
        cursorColor: AppColors.whiteColor,
        textInputAction: widget.textInputAction,
        readOnly: widget.readOnly,
        onFieldSubmitted: (value) {
          if (widget.onFieldSubmitted != null) {
            widget.onFieldSubmitted!(value);
          }
        },
        decoration: InputDecoration(
          hintText: widget.hintText ?? "",
          hintStyle: widget.hintStyle ??
              TextStyle(
                color: AppColors.greyColor130,
                fontSize: ScreenSize.fontSize14,
              ),
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          isDense: true,
        ),
        style: widget.inputStyle ??
            TextStyle(
              color: AppColors.whiteColor,
              fontSize: ScreenSize.fontSize14,
            ),
        controller: widget.controller,
      ),
    );
  }
}
