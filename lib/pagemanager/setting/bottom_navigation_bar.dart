import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/utilities/style/screen_size.dart';
import '../../components/utilities/style/style_config.dart';
import '../../global/global_view_model.dart';
import '../enum/bottom_bar_path.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSize.width,
      child: Center(
        child: Container(
          width: ScreenSize.width,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: Color.fromARGB(221, 58, 57, 57), borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: BottomBarPath.values.map((e) {
              int pageIndex = e.path;

              return GestureDetector(
                  onTap: () {
                    GlobalViewModel().changeMainPage(pageIndex);
                  },
                  child: Container(
                    height: 60,
                    width: (ScreenSize.width - 40) / 5,
                    color: Colors.transparent,
                    child: ref.watch(bottomNavigationBarProvider) == pageIndex
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration:
                                BoxDecoration(color: Color.fromARGB(255, 104, 104, 104), borderRadius: BorderRadius.circular(10)),
                            child: Icon(e.icon, color: AppColors.whiteColor),
                          )
                        : Icon(e.icon, color: Color.fromARGB(255, 136, 130, 130)),
                  ));
            }).toList(),
          ),
        ),
      ),
    );
  }
}
