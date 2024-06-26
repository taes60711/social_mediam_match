import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

///MARK: Base EndDrawer
class EndDrawer extends StatefulWidget {
  final Function onDismissed;
  final String title;
  final Widget child;

  const EndDrawer({
    super.key,
    required this.onDismissed,
    this.title = "",
    required this.child,
  });

  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
              Container(
                color: Colors.white,
                child: BaseTopBar(
                  title: widget.title,
                  backFunc: () async {
                    await _controller.reverse();
                    widget.onDismissed();
                  },
                ),
              ),
              Expanded(child: widget.child),
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

//未來淘汰
class CustomEndDrawer extends StatefulWidget {
  final Widget child;

  const CustomEndDrawer({super.key, required this.child});

  @override
  _CustomEndDrawer createState() => _CustomEndDrawer();
}

class _CustomEndDrawer extends State<CustomEndDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
        child: Stack(
          children: [
            Positioned(
              height: MediaQuery.of(context).viewPadding.top,
              left: 0,
              right: 0,
              child: Container(color: Colors.white),
            ),
            SafeArea(
              child: widget.child,
            ),
            Positioned(
              height: MediaQuery.of(context).viewPadding.bottom,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(color: Colors.white),
            ),
          ],
        ));
  }
}
