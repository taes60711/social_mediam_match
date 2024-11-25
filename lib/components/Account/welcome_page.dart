import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/account/account_main_page.dart';

import 'package:social_mediam_match/components/utilities/common_scaffold.dart';

import '../utilities/style/screen_size.dart';
import '../utilities/style/style_config.dart';
import 'account_page_utilites.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(16)),
      child: Column(
        children: [
          SizedBox(height: ScreenSize.fitPxWidth(100)),

          ///　Logo
          AccountPageUtilites().logo(),
          const Expanded(child: SizedBox(height: 1)),
          AccountPageUtilites().btnContainer(
            onPress: () {
              ref.read(pageControllerProvider).animateToPage(
                    2,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeIn,
                  );
            },
            btnText: "登入",
          ),

          SizedBox(height: ScreenSize.fitPxWidth(16)),
          AccountPageUtilites().btnContainer(
            btnBgColor: AppColors.orangeColor,
            onPress: () {
              ref.read(pageControllerProvider).animateToPage(
                    0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeIn,
                  );
            },
            btnText: "註冊",
          ),

          SizedBox(height: ScreenSize.fitPxWidth(120)),
        ],
      ),
    ));
  }
}
