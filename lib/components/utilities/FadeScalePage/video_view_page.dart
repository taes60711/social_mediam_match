import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_mediam_match/components/utilities/FadeScalePage/base_fade_scale_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../appBar/basic_top_bar.dart';
import '../style/screen_size.dart';
import '../style/style_config.dart';

class VideoViewPage extends BaseFadeScalePage {
  String ytId;
  VideoViewPage({required this.ytId});
  late YoutubePlayerController ytController;
  bool init = false;

  @override
  Future<void> initState(WidgetRef ref) async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    ytController = YoutubePlayerController(
      initialVideoId: ytId,
      flags: const YoutubePlayerFlags(
        disableDragSeek: true,
        autoPlay: true,
        mute: false,
      ),
    )..toggleFullScreenMode();

    init = true;
    render();
  }

  @override
  Widget build(WidgetRef ref) {
    return init
        ? Stack(
            children: [
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  topActions: [
                    BaseTopBar(
                      backFunc: () {
                        closeView();
                      },
                    ),
                  ],
                  controller: ytController,
                  bottomActions: [
                    PlaybackSpeedButton(
                      icon: Icon(
                        FontAwesomeIcons.gear,
                        size: ScreenSize.fontSize18,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    ProgressBar(isExpanded: true),
                    RemainingDuration(),
                    GestureDetector(
                      onTap: () {
                        final Uri _url = Uri.parse("https://www.youtube.com/watch?v=$ytId");
                        launchUrl(_url);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          FontAwesomeIcons.windowRestore,
                          size: ScreenSize.fontSize18,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                    FullScreenButton(
                      controller: ytController,
                    ),
                  ],
                ),
                builder: (context, player) {
                  return Center(child: player);
                },
              ),
            ],
          )
        : Container();
  }

  void closeView() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    closePage();
  }
}
