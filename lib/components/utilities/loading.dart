import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import 'style/screen_size.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(color: AppColors.orangeColor, size: 35),
    );
  }
}

class PostLoading extends StatelessWidget {
  const PostLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxWidth(10),
              vertical: ScreenSize.fitPxWidth(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: ScreenSize.fitPxWidth(5)),
                  child: loadingGreyContainer(
                    width: ScreenSize.fitPxWidth(24),
                    height: ScreenSize.fitPxWidth(24),
                    borderRadius: ScreenSize.fitPxWidth(25),
                  ),
                ),
                SizedBox(width: ScreenSize.fitPxWidth(5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loadingGreyContainer(
                      width: ScreenSize.fitPxWidth(100),
                      height: ScreenSize.fitPxWidth(15),
                      borderRadius: ScreenSize.fitPxWidth(10),
                    ),
                    SizedBox(height: ScreenSize.fitPxWidth(5)),
                    loadingGreyContainer(
                      width: ScreenSize.fitPxWidth(200),
                      height: ScreenSize.fitPxWidth(15),
                      borderRadius: ScreenSize.fitPxWidth(10),
                    ),
                    SizedBox(height: ScreenSize.fitPxWidth(5)),
                    loadingGreyContainer(
                      width: ScreenSize.fitPxWidth(320),
                      height: ScreenSize.fitPxWidth(120),
                      borderRadius: ScreenSize.fitPxWidth(10),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class DetailPageLoading extends StatelessWidget {
  const DetailPageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      loadingGreyContainer(width: 50, height: 50, borderRadius: 25),
                      const SizedBox(width: 10),
                      loadingGreyContainer(width: 50, height: 15),
                    ],
                  ),
                  loadingGreyContainer(width: 60, height: 15),
                ],
              ),
              const SizedBox(height: 10),
              loadingGreyContainer(width: ScreenSize.width - 20, height: 15),
              const SizedBox(height: 5),
              loadingGreyContainer(width: 300, height: 200),
              const SizedBox(height: 5),
              loadingGreyContainer(width: 150, height: 50),
              const SizedBox(height: 5),
              loadingGreyContainer(width: ScreenSize.width - 40, height: 15),
              const SizedBox(height: 5),
              loadingGreyContainer(width: 300, height: 200),
              const SizedBox(height: 5),
              loadingGreyContainer(width: 200, height: 15),
              const SizedBox(height: 5),
              loadingGreyContainer(width: 80, height: 80),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseLoading extends StatelessWidget {
  const CourseLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSize.fitPxWidth(10),
              vertical: ScreenSize.fitPxWidth(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    loadingGreyContainer(
                      width: ScreenSize.fitPxWidth(24),
                      height: ScreenSize.fitPxWidth(24),
                      borderRadius: ScreenSize.fitPxWidth(25),
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(5)),
                    loadingGreyContainer(
                      width: ScreenSize.fitPxWidth(100),
                      height: ScreenSize.fitPxWidth(15),
                      borderRadius: ScreenSize.fitPxWidth(10),
                    ),
                  ],
                ),
                SizedBox(height: ScreenSize.fitPxWidth(5)),
                loadingGreyContainer(
                  width: ScreenSize.fitPxWidth(200),
                  height: ScreenSize.fitPxWidth(15),
                  borderRadius: ScreenSize.fitPxWidth(10),
                ),
                SizedBox(height: ScreenSize.fitPxWidth(5)),
                loadingGreyContainer(
                  width: ScreenSize.fitPxWidth(320),
                  height: ScreenSize.fitPxWidth(15),
                  borderRadius: ScreenSize.fitPxWidth(10),
                ),
                SizedBox(height: ScreenSize.fitPxWidth(5)),
                loadingGreyContainer(
                  width: ScreenSize.fitPxWidth(60),
                  height: ScreenSize.fitPxWidth(15),
                  borderRadius: ScreenSize.fitPxWidth(10),
                ),
                SizedBox(height: ScreenSize.fitPxWidth(5)),
                loadingGreyContainer(
                  width: ScreenSize.fitPxWidth(120),
                  height: ScreenSize.fitPxWidth(15),
                  borderRadius: ScreenSize.fitPxWidth(10),
                ),
                SizedBox(height: ScreenSize.fitPxWidth(5)),
                loadingGreyContainer(
                  width: ScreenSize.fitPxWidth(60),
                  height: ScreenSize.fitPxWidth(15),
                  borderRadius: ScreenSize.fitPxWidth(10),
                ),
                SizedBox(height: ScreenSize.fitPxWidth(5)),
                loadingGreyContainer(
                  width: ScreenSize.fitPxWidth(120),
                  height: ScreenSize.fitPxWidth(15),
                  borderRadius: ScreenSize.fitPxWidth(10),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SkillChangeLoading extends StatelessWidget {
  const SkillChangeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loadingGreyContainer(
                      width: ScreenSize.fitPxWidth(65),
                      height: ScreenSize.fitPxWidth(65),
                      borderRadius: ScreenSize.fitPxWidth(10),
                    ),
                    SizedBox(width: ScreenSize.fitPxWidth(5)),
                    loadingGreyContainer(
                      width: ScreenSize.fitPxWidth(90),
                      height: ScreenSize.fitPxWidth(15),
                      borderRadius: ScreenSize.fitPxWidth(15),
                    ),
                    const Expanded(child: SizedBox(width: 1)),
                    loadingGreyContainer(
                      width: ScreenSize.fitPxWidth(40),
                      height: ScreenSize.fitPxWidth(15),
                      borderRadius: ScreenSize.fitPxWidth(12),
                    ),
                  ],
                ),
                SizedBox(height: ScreenSize.fitPxWidth(5)),
                loadingGreyContainer(
                  width: ScreenSize.fitPxWidth(130),
                  height: ScreenSize.fitPxWidth(15),
                  borderRadius: ScreenSize.fitPxWidth(15),
                ),
                SizedBox(height: ScreenSize.fitPxWidth(5)),
                loadingGreyContainer(
                  width: ScreenSize.fitPxWidth(150),
                  height: ScreenSize.fitPxWidth(15),
                  borderRadius: ScreenSize.fitPxWidth(15),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget loadingGreyContainer({required double width, required double height, double? borderRadius}) {
  return Shimmer.fromColors(
    baseColor: AppColors.greyColor98,
    highlightColor: AppColors.greyColor98.withOpacity(.7),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.greyColor98,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
    ),
  );
}
