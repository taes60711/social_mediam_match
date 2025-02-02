import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/style/app_colors.dart';

import '../style/screen_size.dart';

abstract class BaseOverlayBottomSheet {
  late AnimationController controller;
  late OverlayEntry _overlayEntry;
  late Function render;
  bool _isInit = false;

  // （レンダリング、APIとか必要場合）
  Future<void> initState(WidgetRef ref) async {}

  Widget build(WidgetRef ref);

  Widget downWidgetBuild(WidgetRef ref) {
    return Container();
  }

  void show(BuildContext context, {double height = 0.6}) {
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

                  Future.delayed(Duration.zero).then((value) {
                    initState(ref).then((value) => _isInit = true);
                  });
                }
                return BottomSheetWidget(
                  widgetHeight: ScreenSize.height * height,
                  closeFunc: () => closePage(),
                  callBackAnimationController: (AnimationController animationController) {
                    controller = animationController;
                  },
                  downWidget: downWidgetBuild(ref),
                  child: build(ref),
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
  final Widget? downWidget;
  const BottomSheetWidget({
    super.key,
    required this.widgetHeight,
    required this.closeFunc,
    required this.callBackAnimationController,
    required this.child,
    this.downWidget,
  });

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double _dragStartY = 0;
  double lastDragStartY = 0;
  double contianerHeight = 0;

  int _isDraggingDownStatus = 0; // 0:不要影響  1 :下滑  2:上滑

  @override
  void initState() {
    super.initState();
    contianerHeight = widget.widgetHeight;
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
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    double dragDelta = details.globalPosition.dy - _dragStartY;
    _isDraggingDownStatus = 0;

    /// 滑動距離大於3
    if ((dragDelta - lastDragStartY).abs() > 2) {
      if (dragDelta > 0) {
        /// 下滑
        _isDraggingDownStatus = 1;
      } else if (dragDelta < 0) {
        /// 上滑
        _isDraggingDownStatus = 2;
      }
    }

    _dragStartY = details.globalPosition.dy;

    double wantMoveHeight = contianerHeight - dragDelta;

    if (wantMoveHeight >= ScreenSize.fitPxHeight(100) && wantMoveHeight <= widget.widgetHeight) {
      contianerHeight = wantMoveHeight;
      setState(() {});
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_isDraggingDownStatus == 1) {
      if (contianerHeight >= ScreenSize.fitPxHeight(200)) {
        contianerHeight = ScreenSize.fitPxHeight(200);
      }
    } else if (_isDraggingDownStatus == 2) {
      contianerHeight = widget.widgetHeight;
    }
    if (contianerHeight < ScreenSize.fitPxHeight(200)) {
      widget.closeFunc();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: contianerHeight,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
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
                  Expanded(child: widget.child),
                  widget.downWidget ?? Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
