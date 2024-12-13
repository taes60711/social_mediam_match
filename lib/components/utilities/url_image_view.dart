import 'package:flutter/material.dart';

/// 處理API的圖片
class APIImageView extends StatefulWidget {
  final String imgUrl;
  final String? noDataImgPath;
  final Widget? noDataBuilder;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  const APIImageView({
    super.key,
    this.imgUrl = "",
    this.width,
    this.height,
    this.color,
    this.fit,
    this.noDataImgPath,
    this.noDataBuilder,
  });

  @override
  State<APIImageView> createState() => _APIImageViewState();
}

class _APIImageViewState extends State<APIImageView> {
  @override
  Widget build(BuildContext context) {
    return widget.imgUrl == ""
        ? noImgBuilder()
        : Image.network(
            widget.imgUrl,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                width: widget.width,
                height: widget.height,
                child: const Center(child: Text("imgUrlErr")),
              );
            },
          );
  }

  Widget noImgBuilder() {
    if (widget.noDataBuilder == null && widget.noDataImgPath == null) {
      return const Text("pls use noDataBuilder or noDataImgPath");
    }
    if (widget.noDataBuilder == null) {
      return Image.asset(
        widget.noDataImgPath ?? "",
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    } else {
      return widget.noDataBuilder ?? Container();
    }
  }
}