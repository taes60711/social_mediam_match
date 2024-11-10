import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/background_widget.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

///MARK: Base EndDrawer
class EndDrawer extends StatefulWidget {
  final Function onDismissed;
  final String title;
  final Widget child;
  final Widget? loadingBuilder;
  final bool isNeedTopbar;

  const EndDrawer({
    super.key,
    required this.onDismissed,
    this.title = "",
    required this.child,
    this.loadingBuilder,
    this.isNeedTopbar = true,
  });

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 20));
      if (widget.loadingBuilder != null) {
        loading = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * MediaQuery.of(context).size.width, 0),
          child: child,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Dismissible(
          direction: DismissDirection.startToEnd,
          resizeDuration: const Duration(milliseconds: 1),
          onDismissed: (_) {
            widget.onDismissed();
          },
          key: const Key('key'),
          child: Column(
            children: [
              Container(
                width: ScreenSize.width,
                height: MediaQuery.of(context).viewPadding.top,
                color: Colors.white,
              ),
              Visibility(
                visible: widget.isNeedTopbar,
                child: Container(
                  color: Colors.white,
                  child: BaseTopBar(
                    title: widget.title,
                    backFunc: () async {
                      await _controller.reverse();
                      widget.onDismissed();
                    },
                  ),
                ),
              ),
              Expanded(
                child: widget.loadingBuilder != null && loading
                    ? Scaffold(
                        body: widget.loadingBuilder,
                      )
                    : widget.child,
              ),
              Container(
                width: ScreenSize.width,
                height: MediaQuery.of(context).viewPadding.bottom,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class BaseEndDrawer {
  late AnimationController controller;
  late Function closePage;
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
        reverseTransitionDuration: const Duration(milliseconds: 150),
        transitionDuration: Duration.zero,
        pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: EndDrawerWidget(
              callBackAnimationController: (AnimationController animationController) => controller = animationController,
              needWaitPageOpen: needWaitOpenPage(),
              callBackClosePage: (Function callBackClosePage) {
                closePage = () {
                  callBackClosePage();
                };
              },
              closeDispose: () {
                dispose(ref);
              },
              child: Consumer(
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

class EndDrawerWidget extends ConsumerStatefulWidget {
  final Widget child;
  final bool needWaitPageOpen;
  final Function closeDispose;

  final Function(AnimationController controller) callBackAnimationController;
  final Function(Function closepage) callBackClosePage;
  const EndDrawerWidget({
    super.key,
    required this.child,
    required this.callBackAnimationController,
    required this.callBackClosePage,
    this.needWaitPageOpen = false,
    required this.closeDispose,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EndDrawerWidgetState createState() => _EndDrawerWidgetState();
}

class _EndDrawerWidgetState extends ConsumerState<EndDrawerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;
  double _dragStartX = 0.0;
  bool isInit = true;
  bool isDispose = false;

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

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(Duration.zero).then((value) {
      _controller.forward().whenComplete(() {
        widget.callBackAnimationController(_controller);
        widget.callBackClosePage(() => _closeEndDrawer());
        isInit = true;
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    double dragDelta = details.globalPosition.dx - _dragStartX;
    double dragFraction = dragDelta / MediaQuery.of(context).size.width;
    _controller.value = 1 - dragFraction;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_controller.value < 0.85) {
      _closeEndDrawer();
    } else {
      _controller.forward();
    }
  }

  void _closeEndDrawer() {
    isDispose = true;
    widget.closeDispose();
    setState(() {});
    _controller.reverse();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget component = Container();

    if (isDispose) {
      component = Container();
    } else if (!isInit) {
      component = const Center(
        child: Loading(),
      );
    } else {
      component = widget.child;
    }
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _offsetAnimation,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppColors.bgColor,
            child: CommonScaffold(
              child: component,
            ),
          ),
        ),
      ),
    );
  }
}
