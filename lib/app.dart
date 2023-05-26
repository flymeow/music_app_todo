import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music/common/footer/bottom_bar.dart';
import 'package:flutter_music/common/mini_player/mini_player.dart';
import 'package:flutter_music/common/player_screen/player_screen.dart';
import 'package:flutter_music/config/themes/app_theme.dart';
import 'package:flutter_music/providers/playlist_model.dart';
import 'package:provider/provider.dart';

import 'package:flutter_music/views/account/account.dart';
import 'package:flutter_music/views/favorite/favorite.dart';
import 'package:flutter_music/views/home/home.dart';
import 'package:we_slide/we_slide.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _currentIndex = 0;
  WeSlideController slideController = WeSlideController();

  @override
  void initState() {
    super.initState();

    slideController.addListener(() {
      if (!slideController.isOpened) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      } else {
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        //     overlays: [SystemUiOverlay.top]);
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      }
    });
  }

  Future<bool> _handleBack() async {
    if (slideController.isOpened) {
      slideController.hide();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    void _handleChange(int value) {
      setState(() {
        _currentIndex = value;
      });
    }

    const double _panelMinSize = 120;
    final double _panelMaxSize = MediaQuery.of(context).size.height;

    bool showMiniPlayer = context.watch<AudioProvider>().showMiniPlayer;
    if (_panelMaxSize == 0) {
      return Container();
    }

    return Scaffold(
      backgroundColor: AppTheme.basic.primaryColor,
      body: WillPopScope(
        onWillPop: _handleBack,
        child: WeSlide(
          controller: slideController,
          parallax: true, // 视差效果
          hideAppBar: false,
          panelMinSize: showMiniPlayer ? _panelMinSize : 0,
          panelMaxSize: _panelMaxSize,
          panelBorderRadiusBegin: 0.0,
          panelBorderRadiusEnd: 0.0,
          parallaxOffset: 0.0,
          appBarHeight: 0.0,
          footerHeight: 50.0,
          overlayOpacity: 0.6,
          blur: true,
          overlay: false,
          isDismissible: true,
          body: IndexedStack(
            index: _currentIndex,
            children: const [Home(), Favorite(), Account()],
          ),
          panel: showMiniPlayer
              ? PlayerScreen(
                  onTap: () {
                    slideController.hide();
                  },
                  songModelList: const [],
                )
              : Container(),
          panelHeader: showMiniPlayer
              ? MiniPlayer(
                  onTap: () {
                    slideController.show();
                  },
                )
              : null,
          footer: BottomBar(active: _currentIndex, onChange: _handleChange),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // slideController.dispose();
    super.dispose();
  }
}
