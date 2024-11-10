import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';

import '../../utilities/inputField/base_input.dart';
import '../../utilities/style/screen_size.dart';
import '../../utilities/style/style_config.dart';

class SearchUserPage extends BaseBottomSheet {
  @override
  Widget build(WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10)),
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxHeight(10)),
          _buildSearchBar(ref, () => render(), context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref, Function render, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyColor57,
        borderRadius: BorderRadius.circular(5),
      ),
      height: 36,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.search, color: AppColors.whiteColor),
          ),
          Expanded(
            child: BaseInputField(
              hintText: "搜尋",
              controller: TextEditingController(),
            ),
          ),
        ],
      ),
    );
  }
}
