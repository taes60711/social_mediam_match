import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/basic_top_bar.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

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
  void show(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: EndDrawerWidget(),
          );
        },
        opaque: false,
      ),
    );
  }
}

class EndDrawerWidget extends StatefulWidget {
  const EndDrawerWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EndDrawerWidgetState createState() => _EndDrawerWidgetState();
}

class _EndDrawerWidgetState extends State<EndDrawerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double _dragStartX = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _controller.forward();
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
      _controller.reverse().whenComplete(() => Navigator.pop(context));
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromARGB(255, 31, 30, 30),
          child: Builder(builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  _controller.reverse().whenComplete(() => Navigator.pop(context));
                },
                child: Text("exit"),
              ),
            );
          }),
        ),
      ),
    );
  }
}
