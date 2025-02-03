import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../style/app_colors.dart';
import '../style/screen_size.dart';

abstract class BaseDialog {
  late Function closePage;

  late Function render;
  late WidgetRef ref;
  late BuildContext context;
  bool _isInit = false;
  bool buildneedbarrerierClose() {
    return true;
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
    Color barrerierColor = Colors.black.withOpacity(.3);
    Navigator.of(buildContext).push(
      PageRouteBuilder(
        reverseTransitionDuration: Duration.zero,
        transitionDuration: Duration.zero,
        pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Dialog(
            callBackClosePage: (Function callBackClosePage) {
              closePage = callBackClosePage;
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

                    return GestureDetector(
                      onTap: () {
                        if (buildneedbarrerierClose()) {
                          closePage();
                          render();
                        }
                      },
                      child: Scaffold(
                        backgroundColor: AppColors.transparent,
                        body: Container(
                          height: ScreenSize.height,
                          width: ScreenSize.width,
                          color: barrerierColor,
                          child: GestureDetector(
                            onTap: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                build(ref),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          );
        },
        opaque: false,
      ),
    );
  }
}

class Dialog extends StatefulWidget {
  final Function(Function closepage) callBackClosePage;

  final Function closeDispose;

  final Widget child;
  const Dialog({
    super.key,
    required this.callBackClosePage,
    required this.child,
    required this.closeDispose,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DialogState createState() => _DialogState();
}

class _DialogState extends State<Dialog> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widget.callBackClosePage(() => _exitPage());
    setState(() {});
  }

  void _exitPage() async {
    widget.closeDispose();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
