import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/Icon_with_input.dart';

import '../../../states/user_state.dart';
import '../../utilities/custom_button.dart';
import '../../utilities/style/style_config.dart';

class SignUpStepTwo extends StatelessWidget {
  final UserState userFuture;
  const SignUpStepTwo({
    super.key,
    required this.userFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text("個人資料設定")),
        const SizedBox(height: 10),
        TitleInput(title: "職業", inputHeight: 36, textController: TextEditingController()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            title: "送出",
            titleColor: normalTextColor,
            backgroundColor: normalBgColor,
            onPress: () async {
              userFuture.onChangePage(3);
            },
          ),
        ),
      ],
    );
  }
}
