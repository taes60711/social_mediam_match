import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_mediam_match/components/utilities/app_common_tools.dart';

import 'package:social_mediam_match/components/utilities/dialog/base_dialog.dart';
import 'package:social_mediam_match/components/utilities/main_button.dart';

import '../../../utilities/style/app_colors.dart';
import '../../../utilities/style/screen_size.dart';

/// 使用者條款
class UsageTermsDialog extends BaseDialog {
  @override
  Widget build(WidgetRef ref) {
    return Container(
      height: ScreenSize.fitPxWidth(500),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.fitPxWidth(10),
        vertical: ScreenSize.fitPxHeight(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: ScreenSize.fitPxWidth(10)),
      decoration: BoxDecoration(
        color: AppColors.greyColor54,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: SizedBox(width: 1),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "使用者條款",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: ScreenSize.fontSize16),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: MainBtn(
                    onPress: () {
                      closePage();
                    },
                    child: Container(
                      width: ScreenSize.fitPxWidth(40),
                      height: ScreenSize.fitPxWidth(40),
                      color: Colors.transparent,
                      child: Icon(Icons.close, color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCommonTools().titleBuild(str: "使用者條款 (EULA)"),
                  SizedBox(height: ScreenSize.fitPxWidth(5)),
                  AppCommonTools().strBuild(str: "歡迎使用 SkillStorm（以下簡稱「本應用程式」）。為了維護良好的社群環境，使用本應用程式時，您必須遵守以下規範："),
                  SizedBox(height: ScreenSize.fitPxWidth(10)),
                  AppCommonTools().titleBuild(str: "1. 禁止發布不當內容"),
                  SizedBox(height: ScreenSize.fitPxWidth(5)),
                  AppCommonTools().strBuild(str: "您不得在本應用程式上傳、發佈、分享或傳播以下內容，包括但不限於："),
                  AppCommonTools().strBuild(str: "非法內容（如違反當地法律的資訊、詐騙內容等）。"),
                  AppCommonTools().strBuild(str: "裸露或色情內容（包含但不限於成人內容、性暗示、露骨圖片或影片）。"),
                  AppCommonTools().strBuild(str: "仇恨言論與歧視（針對種族、性別、宗教、國籍、性取向等的攻擊或歧視）。"),
                  AppCommonTools().strBuild(str: "網路謾罵、霸凌與騷擾（對其他使用者進行侮辱、恐嚇、威脅或騷擾）。"),
                  AppCommonTools().strBuild(str: "暴力內容（包含恐怖主義、血腥畫面或其他令人不適的內容）。"),
                  AppCommonTools().strBuild(str: "侵犯他人隱私或智慧財產權的內容（如未經授權的照片、影片或機密資訊）。"),
                  SizedBox(height: ScreenSize.fitPxWidth(10)),
                  AppCommonTools().titleBuild(str: "2. 違規處理"),
                  SizedBox(height: ScreenSize.fitPxWidth(5)),
                  AppCommonTools().strBuild(str: "若您發佈違規內容，本應用程式的管理團隊有權不經通知直接刪除該內容。"),
                  AppCommonTools().strBuild(str: "若您多次違規，我們有權暫停或永久停用您的帳號，且不另行通知。"),
                  SizedBox(height: ScreenSize.fitPxWidth(10)),
                  AppCommonTools().titleBuild(str: "3. 使用者舉報與封鎖"),
                  SizedBox(height: ScreenSize.fitPxWidth(5)),
                  AppCommonTools().strBuild(str: "若您發現其他使用者發佈不適當內容，可以透過應用程式內的**「檢舉」功能**向我們回報，我們將在 24 小時內處理。"),
                  AppCommonTools().strBuild(str: "若您不希望與特定使用者互動，可使用**「封鎖」功能**避免與其聯繫。"),
                  SizedBox(height: ScreenSize.fitPxWidth(10)),
                  AppCommonTools().titleBuild(str: "4. 條款更新"),
                  SizedBox(height: ScreenSize.fitPxWidth(5)),
                  AppCommonTools().strBuild(str: "我們可能會根據法律要求或社群管理需求對本條款進行修改，更新後的條款將在本應用程式內公佈，繼續使用本應用程式即表示您同意新的條款。"),
                  SizedBox(height: ScreenSize.fitPxWidth(10)),
                  AppCommonTools().titleBuild(str: "5. 聯絡我們"),
                  SizedBox(height: ScreenSize.fitPxWidth(5)),
                  AppCommonTools().strBuild(str: "若您對本條款有任何疑問，請透過 directsenseservice@gmail.com 或著本應用程式的回報功能與我們聯繫。"),
                  SizedBox(height: ScreenSize.fitPxWidth(10)),
                  AppCommonTools().strBuild(str: "感謝您遵守本條款，共同維護良好的社群環境！"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
