import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_music/common/common.dart';
import 'package:flutter_music/common/mini_player/mini_player.dart';
import 'package:flutter_music/common/player_screen/favorite_button.dart';
import 'package:flutter_music/providers/playlist_model.dart';
import 'package:flutter_music/views/home/home.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen(
      {Key? key, required this.onTap, required this.songModelList})
      : super(key: key);
  final VoidCallback? onTap;
  final List<SongModel> songModelList;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // 动画控制器

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8), //单次动画旋转所需时间
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /* 封装的停止、跳过和恢复 */
  void stopAnimation() {
    setState(() {
      if (_controller.isAnimating) _controller.stop(); //如果动画已经在执行，则将其停止。
    });
  }

  void skipAnimation() {
    setState(() {
      if (_controller.isAnimating) _controller.forward(); //如果动画没有完成，则跳转到结束状态。
    });
  }

  void resumeAnimation() {
    setState(
      () {
        if (!_controller.isAnimating) {
          _controller.repeat(); //如果动画已经停止，则将其恢复初始状态并一直旋转。
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SongModel song = context.watch<AudioProvider>().currnetSong;

    var _positionDataStream = context.watch<AudioProvider>().positionDataStream;
    var _player = context.watch<AudioProvider>().player;

    if (context.watch<AudioProvider>().player.playing) {
      resumeAnimation();
    } else {
      stopAnimation();
    }

    return Material(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: <Widget>[
            // 背景图片
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: QueryArtworkWidget(
                quality: 100,
                id: song.id,
                type: ArtworkType.AUDIO,
                artworkHeight: MediaQuery.of(context).size.height,
                artworkWidth: MediaQuery.of(context).size.width,
                artworkFit: BoxFit.cover,
                keepOldArtwork: true,
                artworkBorder: BorderRadius.circular(0),
                nullArtworkWidget: const Icon(
                  Icons.music_note,
                  size: 200,
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  color: Colors.black26,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // child: Column(
              //   children: <Widget>[

              //   ],
              // ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: MediaQueryData.fromWindow(window).padding.top,
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          // 左侧ICON
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => widget.onTap!(),
                            alignment: Alignment.center,
                            iconSize: 34,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                          // 标题
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  song.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  song.artist ?? '',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          // 右侧ICON
                          IconButton(
                            onPressed: () => {},
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // // 旋转动画
                  Positioned(
                    top: MediaQueryData.fromWindow(window).padding.top + 115,
                    child: ControlledRotationWidget(
                      controller: _controller,
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AudioProvider>(context, listen: false)
                              .trigger();
                          logger.w("stop");
                        },
                        child: QueryArtworkWidget(
                          quality: 80,
                          id: song.id,
                          type: ArtworkType.AUDIO,
                          artworkHeight: 220,
                          artworkWidth: 220,
                          artworkFit: BoxFit.cover,
                          artworkBorder: BorderRadius.circular(110),
                          keepOldArtwork: true,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            size: 200,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 260,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 当前播放列表
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.list),
                                  color: Colors.white,
                                ),
                                // 收藏按钮
                                // IconButton(
                                //   onPressed: () {
                                //     // todo
                                //   },
                                //   color: Colors.white,
                                //   icon: const Icon(Icons.favorite),
                                // ),
                                FavoriteButton(song: song),
                                // 播放模式
                                IconButton(
                                  onPressed: () {},
                                  color: Colors.white,
                                  icon: const Icon(Icons.shuffle),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              StreamBuilder<PositionData>(
                                stream: _positionDataStream,
                                builder: (context, snapshot) {
                                  PositionData? positionData = snapshot.data;
                                  return PlayerProgressBar(
                                    position:
                                        positionData?.position ?? Duration.zero,
                                    duration:
                                        positionData?.duration ?? Duration.zero,
                                    onSeek: (duration) {
                                      _player.seek(duration);
                                    },
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const PlayButton(large: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///

class ControlledRotationWidget extends StatefulWidget {
  final Widget child;

  /* 在这里添加一个 controller, 默认开始 */
  final AnimationController controller;

  const ControlledRotationWidget({
    Key? key,
    required this.child,
    required this.controller, // 添加之前构建好的动画控制器
  }) : super(key: key);

  @override
  _ControlledRotationWidgetState createState() =>
      _ControlledRotationWidgetState();
}

class _ControlledRotationWidgetState extends State<ControlledRotationWidget> {
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(widget.controller),
      child: widget.child,
    );
  }
}
