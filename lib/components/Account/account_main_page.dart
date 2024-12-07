import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/account/login_page.dart';
import 'package:social_mediam_match/components/account/welcome_page.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';
import '../../provider/account/signUpPage/sign_up_view_model.dart';
import 'signUpPage/signup_page.dart';

final pageControllerProvider = StateProvider((ref) => PageController(initialPage: 1));

StateProvider<SignUpViewModel> viewModelProvider = StateProvider<SignUpViewModel>((ref) => SignUpViewModel());

class AccountMainPage extends ConsumerStatefulWidget {
  const AccountMainPage({super.key});

  @override
  ConsumerState<AccountMainPage> createState() => _AccountMainPageState();
}

class _AccountMainPageState extends ConsumerState<AccountMainPage> {
  int nowPageIndex = 1;

  @override
  void initState() {
    SignUpViewModel viewModel = SignUpViewModel(ref: ref, context: context);
    Future.delayed(Duration.zero).then((_) {
      ref.read(viewModelProvider.notifier).update((state) => viewModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageWidget = [
      const SignUpPage(),
      const WelcomePage(),
      const LoginPage(),
    ];

    return CommonScaffold(
      child: Stack(
        children: [
          PageView(
            controller: ref.read(pageControllerProvider),
            physics: const ClampingScrollPhysics(),
            children: pageWidget,
            onPageChanged: (value) {
              nowPageIndex = value;
              setState(() {});
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pageWidget.asMap().entries.map((e) {
                int index = e.key;
                bool isInPage = nowPageIndex == index;
                return MainBtn(
                  onPress: () async {
                    if (!isInPage) {
                      if ((ref.read(pageControllerProvider).page! - index).abs() > 1) {
                        ref.read(pageControllerProvider).jumpToPage(
                              index,
                            );
                      } else {
                        await ref.read(pageControllerProvider).animateToPage(
                              index,
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeIn,
                            );
                      }
                    }
                  },
                  child: Container(
                    width: ScreenSize.fitPxWidth(40),
                    height: ScreenSize.fitPxWidth(35),
                    color: Colors.transparent,
                    child: Center(
                      child: isInPage
                          ? Container(
                              width: ScreenSize.fitPxWidth(30),
                              height: ScreenSize.fitPxWidth(12),
                              decoration: BoxDecoration(
                                color: AppColors.greyColor176,
                                borderRadius: BorderRadius.circular(ScreenSize.fitPxWidth(100)),
                              ),
                            )
                          : Container(
                              width: ScreenSize.fitPxWidth(12),
                              height: ScreenSize.fitPxWidth(12),
                              decoration: BoxDecoration(
                                color: AppColors.greyColor54,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
