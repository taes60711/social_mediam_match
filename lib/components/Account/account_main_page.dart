import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/Account/login_page.dart';
import 'package:social_mediam_match/components/Account/welcome_page.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
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
      child: PageView(
        controller: ref.read(pageControllerProvider),
        physics: const ClampingScrollPhysics(),
        children: pageWidget,
      ),
    );
  }
}
