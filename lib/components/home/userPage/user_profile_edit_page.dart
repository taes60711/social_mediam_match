import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/utilities/bottomSheets/base_bottom_sheet.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

class UserProfileEditPage extends BaseBottomSheet {
  @override
  double buildHeight() {
    return 0.9;
  }

  @override
  bool buildneedbarrerierClose() {
    return false;
  }

  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            sss().show(context);
          },
          child: Text("s"),
        ),
      ],
    );
  }
}

class sss extends BaseBottomSheet {
  @override
  double buildHeight() {
    return 0.3;
  }

  @override
  Widget build(WidgetRef ref) {
    List<String> item = ["項目1", "項目2", "項目3", "項目4", "項目5"];
    return CupertinoPicker(
      itemExtent: 50,
      onSelectedItemChanged: (int value) {},
      children: item
          .map(
            (e) => Center(
              child: Text(
                e,
                style: TextStyle(color: AppColors.whiteColor),
              ),
            ),
          )
          .toList(),
    );
  }
}
