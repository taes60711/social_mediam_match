import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:social_mediam_match/components/utilities/custom_expansion_title.dart';
import 'package:social_mediam_match/components/utilities/endDrawers/base_end_drawer.dart';
import 'package:social_mediam_match/components/utilities/style/screen_size.dart';
import 'package:social_mediam_match/components/utilities/style/style_config.dart';

import '../../utilities/appBar/basic_top_bar.dart';

class AboutPage extends BaseEndDrawer {
  @override
  Widget build(WidgetRef ref) {
    return Column(
      children: [
        BaseTopBar(
          title: "關於",
          backFunc: () {
            closePage();
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenSize.fitPxWidth(16),
          ),
          child: CustomExpansionTile(
            isNeedLoadingWidget: false,
            title: Text(
              "程度分級",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: ScreenSize.fontSize18,
              ),
            ),
            collapsedTrailingWidget: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.whiteColor,
            ),
            expandedTrailingWidget: Icon(
              Icons.keyboard_arrow_up,
              color: AppColors.whiteColor,
            ),
            children: [
              SizedBox(height: ScreenSize.fitPxWidth(5)),
              titleBuild(str: "0 級：僅聽過"),
              strBuild(str: "對此技能有聽說過，但沒有任何實際了解或接觸。"),
              SizedBox(height: ScreenSize.fitPxWidth(15)),
              titleBuild(str: "1 級：有基礎認知"),
              strBuild(str: "知道該技能的大致用途，曾看過相關程式碼或別人的使用案例。"),
              strBuild(str: "可能理解基本概念，但未曾實際動手操作。"),
              SizedBox(height: ScreenSize.fitPxWidth(15)),
              titleBuild(str: "2 級：初步了解並有基礎實踐"),
              strBuild(str: "可以使用該技能完成簡單任務，例如寫過基本範例。"),
              strBuild(str: "熟悉基礎語法或功能，但遇到問題時，不具備獨自解決的能力。"),
              SizedBox(height: ScreenSize.fitPxWidth(15)),
              titleBuild(str: "3 級：能應用於日常任務"),
              strBuild(str: "能獨立完成中小型項目，且對該技能的基礎和常見用法有一定的熟悉程度。"),
              strBuild(str: "在有特殊情況時，能通過查閱文檔或範例解決問題，且能夠釐清原因。"),
              SizedBox(height: ScreenSize.fitPxWidth(15)),
              titleBuild(str: "4 級：高效應用並能優化"),
              strBuild(str: "能熟練使用該技能完成一套系統，並且能夠考慮到日後的維護性、可讀性、擴展性等等的優缺點。"),
              strBuild(str: "能夠區分相同領域但不同工具的特性，從中選擇自己要如何應用。"),
              SizedBox(height: ScreenSize.fitPxWidth(15)),
              titleBuild(str: "5 級：專家級精通"),
              strBuild(str: "深入理解該技能的內部實現原理，並有自己的見解。"),
              strBuild(str: "有能力對現有系統進行深度優化。"),
              strBuild(str: "能對該領域提供指導意見或創新解決方案。"),
            ],
          ),
        ),
      ],
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
