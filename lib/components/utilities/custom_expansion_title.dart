import 'package:flutter/material.dart';
import 'package:social_mediam_match/components/utilities/loading.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';

enum ExpansionTilteOnTapPos {
  all,
  traling,
}

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final Widget? expandedTrailingWidget;
  final Widget? collapsedTrailingWidget;
  final List<Widget> children;
  final bool initiallyExpanded;
  final bool isNeedLoadingWidget;
  final ExpansionTilteOnTapPos onTapPos;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.expandedTrailingWidget,
    this.collapsedTrailingWidget,
    required this.children,
    this.initiallyExpanded = false,
    this.isNeedLoadingWidget = true,
    this.onTapPos = ExpansionTilteOnTapPos.all,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeIn));

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (!_isExpanded) {
      setState(() {
        if (widget.isNeedLoadingWidget) {
          _isLoading = true;
        }
        _isExpanded = true;
      });
      _controller.forward().whenComplete(() async {
        if (widget.isNeedLoadingWidget) {
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            _isLoading = false;
          });
        }
      });
    } else {
      _controller.reverse().whenComplete(() {
        setState(() {
          _isExpanded = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: widget.onTapPos == ExpansionTilteOnTapPos.all ? _handleTap : null,
          child: SizedBox(
            width: ScreenSize.width,
            child: Row(
              children: [
                Expanded(child: widget.title),
                widget.expandedTrailingWidget != null || widget.collapsedTrailingWidget != null
                    ? const SizedBox(width: 10)
                    : const SizedBox(),
                GestureDetector(
                  onTap: () => _handleTap(),
                  child:
                      _isExpanded ? widget.expandedTrailingWidget ?? Container() : widget.collapsedTrailingWidget ?? Container(),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedBuilder(
            animation: _controller.view,
            builder: (context, child) {
              return Align(
                heightFactor: _heightFactor.value,
                child: _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Loading(),
                        ),
                      )
                    : _isExpanded
                        ? Column(
                            children: widget.children,
                          )
                        : Container(),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
