import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/common_scaffold.dart';
import '../loading.dart';
import '../style/style_config.dart';

abstract class BaseFadeScalePage {
  late Function closePage;
  late AnimationController controller;
  late Function render;
  late WidgetRef ref;
  late BuildContext context;
  bool _isInit = false;

  bool needWaitOpenPage() {
    return false;
  }

  // initState前に
  void create() {}
  // （レンダリング、APIとか必要場合）
  Future<void> initState(WidgetRef ref) async {}

  // （close）
  Future<void> dispose(WidgetRef ref) async {}

  /// MARK:  mainBody
  Widget build(WidgetRef ref);

  void show(BuildContext buildContext) {
    context = buildContext;
    Navigator.of(buildContext).push(
      PageRouteBuilder(
        reverseTransitionDuration: Duration.zero,
        transitionDuration: Duration.zero,
        pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
          return FadeScale(
            callBackAnimationController: (AnimationController animationController) {
              controller = animationController;
            },
            needWaitPageOpen: needWaitOpenPage(),
            callBackClosePage: (Function callBackClosePage) {
              closePage = callBackClosePage;
            },
            closeDispose: () {
              dispose(ref);
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Consumer(
                builder: ((context, consumerRef, _) {
                  return StatefulBuilder(
                    builder: ((_, setState) {
                      if (!_isInit) {
                        render = () => setState(() {});
                        ref = consumerRef;
                        Future.delayed(Duration.zero).then((value) {
                          create();
                          initState(ref).then((value) => _isInit = true);
                        });
                      }
                      return build(ref);
                    }),
                  );
                }),
              ),
            ),
          );
        },
        opaque: false,
      ),
    );
  }
}

class FadeScale extends StatefulWidget {
  final Function(Function closepage) callBackClosePage;
  final bool needWaitPageOpen;
  final Function closeDispose;
  final Function(AnimationController controller) callBackAnimationController;
  final Widget child;
  const FadeScale({
    super.key,
    required this.callBackAnimationController,
    required this.callBackClosePage,
    required this.child,
    this.needWaitPageOpen = false,
    required this.closeDispose,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FadeScaleState createState() => _FadeScaleState();
}

class _FadeScaleState extends State<FadeScale> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  bool isInit = true;
  @override
  void initState() {
    super.initState();
    if (widget.needWaitPageOpen) {
      isInit = false;
    }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward().whenComplete(() {
      widget.callBackAnimationController(_controller);
      widget.callBackClosePage(() => _exitPage());
      isInit = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _exitPage() async {
    widget.closeDispose();
    _controller.reverse().then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    Widget component = Container();
    if (!isInit) {
      component = const Center(
        child: Loading(),
      );
    } else {
      component = widget.child;
    }
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColors.bgColor,
          child: CommonScaffold(
            child: component,
          ),
        ),
      ),
    );
  }
}
