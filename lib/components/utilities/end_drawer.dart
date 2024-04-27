import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

class EndDrawer {
  BuildContext context;
  EndDrawer({required this.context});
  Future<void> openDialog({required Widget child}) {
    return showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.3),
      builder: (BuildContext context) {
        return RightToLeftAnimationDialog(
          child: Dismissible(
            direction: DismissDirection.startToEnd,
            resizeDuration: const Duration(milliseconds: 1),
            onDismissed: (_) => Navigator.of(context).pop(),
            key: const Key('key'),
            child: Container(
              width: ScreenSize().width,
              height: ScreenSize().height,
              color: Colors.white,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class RightToLeftAnimationDialog extends StatefulWidget {
  final Widget child;

  RightToLeftAnimationDialog({required this.child});

  @override
  _RightToLeftAnimationDialogState createState() => _RightToLeftAnimationDialogState();
}

class _RightToLeftAnimationDialogState extends State<RightToLeftAnimationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
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
      child: widget.child,
    );
  }
}
