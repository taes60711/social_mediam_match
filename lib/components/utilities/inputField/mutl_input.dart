import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';

import '../bottomSheets/base_bottom_sheet.dart';
import '../appBar/basic_top_bar.dart';
import '../style/screen_size.dart';
import '../style/style_config.dart';
import 'base_input.dart';

class MultInput extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? inputStyle;
  final int minLines;
  final int maxLines;
  final int? editPageMinLines;
  final int? editPageMaxLines;

  const MultInput(
      {super.key,
      required this.controller,
      required this.hintText,
      this.hintStyle,
      this.inputStyle,
      required this.minLines,
      required this.maxLines,
      this.editPageMinLines,
      this.editPageMaxLines});

  @override
  ConsumerState<MultInput> createState() => _MultLableInputState();
}

class _MultLableInputState extends ConsumerState<MultInput> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        MultInputBottomSheet(
          textEditingController: widget.controller,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          inputStyle: widget.inputStyle,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          editPageMinLines: widget.editPageMinLines,
          editPageMaxLines: widget.editPageMaxLines,
        ).show(context);
      },
      child: AbsorbPointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor130),
            borderRadius: BorderRadius.circular(
              ScreenSize.fitPxWidth(8),
            ),
          ),
          child: BaseInputField(
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ?? TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize18),
            inputStyle: widget.inputStyle ?? TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
            controller: widget.controller,
            readOnly: true,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
          ),
        ),
      ),
    );
  }
}

class MultInputBottomSheet extends BaseBottomSheet {
  final TextEditingController textEditingController;
  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? inputStyle;
  final int minLines;
  final int maxLines;
  final int? editPageMinLines;
  final int? editPageMaxLines;
  MultInputBottomSheet({
    required this.textEditingController,
    required this.hintText,
    required this.minLines,
    required this.maxLines,
    this.hintStyle,
    this.inputStyle,
    this.editPageMinLines,
    this.editPageMaxLines,
  });
  @override
  double buildHeight() {
    return 0.9;
  }

  @override
  bottomSheetPageType() {
    return BottomSheetPageType.edit;
  }

  @override
  Widget build(WidgetRef ref) {
    return CommonScaffold(
      type: PageType.window,
      bgColor: Colors.transparent,
      child: Column(
        children: [
          BaseTopBar(
            leftWidget: Container(),
            rightWidget: downCloseBtn(onPress: () {
              closePage();
            }),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyColor130),
              borderRadius: BorderRadius.circular(
                ScreenSize.fitPxWidth(8),
              ),
            ),
            child: BaseInputField(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.greyColor130, fontSize: ScreenSize.fontSize18),
              inputStyle: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
              controller: textEditingController,
              minLines: editPageMinLines ?? minLines,
              maxLines: editPageMaxLines ?? maxLines,
            ),
          ),
        ],
      ),
    );
  }
}
