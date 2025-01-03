import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

import '../style/style_config.dart';

enum BottomSheetPageType {
  normal,
  edit,
}

abstract class BaseBottomSheet {
  late AnimationController controller;
  late Function render;
  late Function closePage;
  bool _isInit = false;
  late BuildContext context;

  BottomSheetPageType bottomSheetPageType() {
    return BottomSheetPageType.normal;
  }

  double buildHeight() {
    return 0.8;
  }

  bool buildneedbarrerierClose() {
    return true;
  }

  // initState前に
  void create() {}
  // （レンダリング、APIとか必要場合）
  Future<void> initState(WidgetRef ref) async {}
  // （close）
  Future<void> dispose(WidgetRef ref) async {}

  Widget build(WidgetRef ref);

  void show(BuildContext buildContext) {
    context = buildContext;
    Color barrerierColor = Colors.black.withOpacity(.3);
    Navigator.of(buildContext).push(
      PageRouteBuilder(
        reverseTransitionDuration: const Duration(milliseconds: 150),
        transitionDuration: Duration.zero,
        pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Consumer(
            builder: (context, ref, _) {
              return StatefulBuilder(
                builder: (context, setState) {
                  if (!_isInit) {
                    render = () => setState(() {});
                    Future.delayed(Duration.zero).then((value) {
                      create();
                      initState(ref).then((value) {
                        _isInit = true;
                      });
                    });
                  }

                  return GestureDetector(
                    onTap: () {
                      if (buildneedbarrerierClose()) {
                        closePage();
                        barrerierColor = Colors.transparent;
                        render();
                      }
                    },
                    child: Container(
                      height: ScreenSize.height,
                      color: barrerierColor,
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: GestureDetector(
                          onTap: () {},
                          child: buildHeight() > 0.6
                              ? Column(
                                  children: [
                                    Container(height: ScreenSize.height - (ScreenSize.height * buildHeight())),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics: const NeverScrollableScrollPhysics(),
                                        child: SizedBox(
                                          height: ScreenSize.height * buildHeight(),
                                          child: BottomSheetWidget(
                                            widgetHeight: ScreenSize.height * buildHeight(),
                                            callBackAnimationController: (AnimationController animationController) {
                                              controller = animationController;
                                            },
                                            callBackClosePage: (Function callBackClosePage) {
                                              closePage = callBackClosePage;
                                            },
                                            closeDispose: () {
                                              dispose(ref);
                                            },
                                            pageType: bottomSheetPageType(),
                                            child: build(ref),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: ScreenSize.height * buildHeight(),
                                      child: BottomSheetWidget(
                                        widgetHeight: ScreenSize.height * buildHeight(),
                                        callBackAnimationController: (AnimationController animationController) {
                                          controller = animationController;
                                        },
                                        callBackClosePage: (Function callBackClosePage) {
                                          closePage = callBackClosePage;
                                        },
                                        closeDispose: () {
                                          dispose(ref);
                                        },
                                        pageType: bottomSheetPageType(),
                                        child: build(ref),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        opaque: false,
      ),
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  final double widgetHeight;
  final Function closeDispose;
  final Function(AnimationController controller) callBackAnimationController;
  final Function(Function closepage) callBackClosePage;
  final Widget child;
  final BottomSheetPageType pageType;

  const BottomSheetWidget({
    super.key,
    required this.widgetHeight,
    required this.callBackAnimationController,
    required this.callBackClosePage,
    required this.child,
    required this.closeDispose,
    required this.pageType,
  });

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  double _currentDragOffset = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration.zero).then((_) {
      _controller.forward().whenComplete(() {
        widget.callBackAnimationController(_controller);
        widget.callBackClosePage(() => _closeEndDrawer());
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _currentDragOffset += details.delta.dy;
      double dragFraction = _currentDragOffset / widget.widgetHeight;
      _controller.value = (1 - dragFraction).clamp(0.0, 1.0);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_controller.value < 0.85) {
      _closeEndDrawer();
    } else {
      _controller.forward();
    }
    _currentDragOffset = 0;
  }

  void _closeEndDrawer() {
    widget.closeDispose();
    _controller.reverse();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: BottomSheetPageType.edit == widget.pageType ? null : _onVerticalDragUpdate,
      onVerticalDragEnd: BottomSheetPageType.edit == widget.pageType ? null : _onVerticalDragEnd,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          width: ScreenSize.width,
          decoration: BoxDecoration(
            color: AppColors.black37,
            borderRadius: BorderRadius.vertical(top: Radius.circular(BottomSheetPageType.edit == widget.pageType ? 0 : 15)),
          ),
          child: Column(
            children: [
              Visibility(
                visible: BottomSheetPageType.normal == widget.pageType,
                child: Container(
                  width: ScreenSize.width * 0.1,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor98,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(child: widget.child),
            ],
          ),
        ),
      ),
    );
  }
}
