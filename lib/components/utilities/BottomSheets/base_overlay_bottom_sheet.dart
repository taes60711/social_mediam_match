import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../style/screen_size.dart';

abstract class BaseOverlayBottomSheet {
  late AnimationController controller;
  late OverlayEntry _overlayEntry;
  late Function render;
  bool _isInit = false;

  // （レンダリング、APIとか必要場合）
  Future<void> initState(WidgetRef ref) async {}

  Widget build(WidgetRef ref);

  void show(BuildContext context, {double height = 0.3}) {
    double sHeight = ScreenSize.height * height;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Consumer(
          builder: (context, ref, _) {
            return StatefulBuilder(
              builder: (context, setState) {
                if (!_isInit) {
                  render = () => setState(() {});
                  _isInit = true;
                }

                return AnimatedContainer(
                  height: sHeight,
                  duration: const Duration(milliseconds: 150),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: BottomSheetWidget(
                      widgetHeight: sHeight,
                      closeFunc: () => closePage(),
                      callBackAnimationController: (AnimationController animationController) {
                        controller = animationController;
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(5)),
                            child: GestureDetector(
                              onTap: () {
                                if (sHeight == ScreenSize.height * height) {
                                  sHeight = ScreenSize.safeHeight;
                                } else {
                                  sHeight = ScreenSize.height * height;
                                }
                                render();
                              },
                              child: Container(
                                width: ScreenSize.fitPxWidth(40),
                                color: Colors.transparent,
                                child: Icon(
                                  sHeight == ScreenSize.height * height ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  size: ScreenSize.fitPxWidth(30),
                                  color: AppColors.greyColor130,
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: build(ref)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry);
  }

  Future<void> closePage() async {
    await controller.reverse();
    _overlayEntry.remove();
  }
}

class BottomSheetWidget extends StatefulWidget {
  final double widgetHeight;
  final Function closeFunc;
  final Function(AnimationController controller) callBackAnimationController;
  final Widget child;
  const BottomSheetWidget({
    super.key,
    required this.widgetHeight,
    required this.closeFunc,
    required this.callBackAnimationController,
    required this.child,
  });

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double _dragStartY = 0;
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

    _controller.forward().whenComplete(() {
      widget.callBackAnimationController(_controller);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    if (_dragStartY == 0) {
      _dragStartY = details.globalPosition.dy;
    }
  }

  // void _onVerticalDragUpdate(DragUpdateDetails details) {
  //   double dragDelta = details.globalPosition.dy - _dragStartY;
  //   _currentDragOffset += dragDelta;
  //   double dragFraction = _currentDragOffset / widget.widgetHeight;
  //   _controller.value = (1 - dragFraction).clamp(0.2, 1.0);
  //   _dragStartY = details.globalPosition.dy;
  // }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _currentDragOffset += details.delta.dy;
      double dragFraction = _currentDragOffset / widget.widgetHeight;
      _controller.value = (1 - dragFraction).clamp(0.0, 1.0);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_controller.value < 0.85) {
      widget.closeFunc();
    } else {
      _controller.forward();
    }
    _currentDragOffset = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          width: ScreenSize.width,
          decoration: BoxDecoration(
            color: AppColors.black37,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            children: [
              Container(
                width: ScreenSize.width * 0.1,
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyColor98,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(child: widget.child)
            ],
          ),
        ),
      ),
    );
  }
}
