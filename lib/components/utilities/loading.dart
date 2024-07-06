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
      child: LoadingAnimationWidget.hexagonDots(color: normalBgColor, size: 35),
    );
  }
}

class PostLoading extends StatelessWidget {
  const PostLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 8, left: 8, right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: const Color.fromARGB(255, 214, 214, 214),
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(35 / 2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 100,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 13,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            subtitle: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                padding: const EdgeInsets.all(5),
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: ScreenSize.width,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 40,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 40,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 40,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            width: 25,
                            height: 11,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
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

class SkillChangeLoading extends StatelessWidget {
  const SkillChangeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                loadingGreyContainer(width: 65, height: 100, borderRadius: 2),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      loadingGreyContainer(width: 60, height: 13),
                      const SizedBox(height: 5),
                      loadingGreyContainer(width: 30, height: 10),
                      const SizedBox(height: 5),
                      loadingGreyContainer(width: ScreenSize.width, height: 26),
                      const SizedBox(height: 5),
                      loadingGreyContainer(width: 70, height: 12),
                      const SizedBox(height: 5),
                      loadingGreyContainer(width: 150, height: 13),
                      const SizedBox(height: 5),
                      loadingGreyContainer(width: 70, height: 12),
                      const SizedBox(height: 5),
                      loadingGreyContainer(width: 150, height: 13),
                    ],
                  ),
                ),
                loadingGreyContainer(width: 40, height: 12),
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
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
    ),
  );
}
