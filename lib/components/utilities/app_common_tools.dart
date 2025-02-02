import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'endDrawers/level_setsumei_end_drawer.dart';
import 'main_button.dart';
import 'style/screen_size.dart';
import 'style/app_colors.dart';

class AppCommonTools {
  Widget levelsetsumeiBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ScreenSize.fitPxWidth(5)),
        titleBuild(str: "1 級：僅聽過"),
        strBuild(str: "對此技能有聽說過，但沒有任何實際了解或接觸。"),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
        titleBuild(str: "2 級：有基礎認知"),
        strBuild(str: "可能理解基本概念，但未曾實際動手操作。"),
        strBuild(str: "知道該技能的大致用途，曾看過相關程式碼或別人的使用案例。"),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
        titleBuild(str: "3 級：初步了解並有基礎實踐"),
        strBuild(str: "可以使用該技能完成簡單專案，例如寫過基本範例。"),
        strBuild(str: "熟悉基礎語法或功能，但遇到問題時，不具備獨自解決的能力。"),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
        titleBuild(str: "4 級：能應用於日常任務"),
        strBuild(str: "在遇到問題時，能通過查閱文檔或範例解決問題，且能夠釐清原因。"),
        strBuild(str: "能獨立完成中小型專案，且對該技能的基礎和常見用法有一定的熟悉程度。"),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
        titleBuild(str: "5 級：高效應用並能優化"),
        strBuild(str: "能夠區分相同領域但不同工具的特性，並根據情況選擇如何應用。"),
        strBuild(str: "能夠熟練使用該技能完成大型專案，並且能夠考慮到日後的維護性、可讀性、擴展性等等的優缺點。"),
        SizedBox(height: ScreenSize.fitPxWidth(15)),
      ],
    );
  }

  Widget levelSetsumeiBtn(BuildContext context) {
    return MainBtn(
      onPress: () {
        LevelsetsumeiEndDrawer().show(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greyColor130,
          borderRadius: BorderRadius.circular(ScreenSize.fontSize24),
        ),
        margin: EdgeInsets.only(right: ScreenSize.fitPxWidth(8)),
        padding: EdgeInsets.all(ScreenSize.fitPxWidth(5)),
        child: Icon(
          FontAwesomeIcons.question,
          color: AppColors.whiteColor,
          size: ScreenSize.fontSize14,
        ),
      ),
    );
  }

  Widget notificationDotWidget(bool condiion, {int? notReadCount}) {
    return Visibility(
      visible: condiion,
      child: notReadCount == null
          ? Container(
              width: ScreenSize.fitPxWidth(6),
              height: ScreenSize.fitPxWidth(6),
              decoration: BoxDecoration(
                color: AppColors.redColor,
                borderRadius: BorderRadius.circular(
                  ScreenSize.fontSize16,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: AppColors.redColor,
                borderRadius: BorderRadius.circular(
                  ScreenSize.fontSize16,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(8)),
              child: Text(
                "$notReadCount",
                style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize12),
              ),
            ),
    );
  }

  Widget titleBuild({required String str}) {
    return Text(
      str,
      style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize18),
    );
  }

  Widget strBuild({required String str}) {
    return Text(
      str,
      style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize14),
    );
  }
}
