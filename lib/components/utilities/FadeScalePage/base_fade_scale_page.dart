import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../background_widget.dart';

abstract class BaseFadeScalePage {
  /// MARK:  mainBody
  Widget build(WidgetRef ref);

  late BuildContext context;
  void show(BuildContext buildContext) {
    context = buildContext;
    Navigator.of(buildContext).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
          return FadeScale(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Consumer(
                builder: ((context, ref, _) {
                  return StatefulBuilder(
                    builder: ((_, setState) {
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
  final Widget child;
  const FadeScale({
    super.key,
    required this.child,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FadeScaleState createState() => _FadeScaleState();
}

class _FadeScaleState extends State<FadeScale> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _exitPage() async {
    _controller.reverse().then((_) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SafeArea(
          child: CommonScaffold(
            child: Center(
              child: ElevatedButton(
                onPressed: _exitPage,
                child: Text("exit"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
