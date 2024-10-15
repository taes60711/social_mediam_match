import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/pagemanager/setting/route_controller.dart';

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

class BaseEndDrawer {
  void turnOn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EndDrawerWidget(),
      ),
    );
  }
}

class EndDrawerWidget extends StatefulWidget {
  const EndDrawerWidget({super.key});

  @override
  State<EndDrawerWidget> createState() => _EndDrawerWidgetState();
}

class _EndDrawerWidgetState extends State<EndDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width,
      height: ScreenSize.height,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 100,
          ),
          ElevatedButton(
              onPressed: () {
                RouteOptions.pop();
              },
              child: Text("exit"))
        ],
      ),
    );
  }
}
