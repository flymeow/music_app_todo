import 'package:flutter/material.dart';
import 'package:flutter_music/common/common.dart';
import 'package:flutter_music/providers/playlist_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final audioPlayer = AudioPlayer();

  // Future<void> playSong(curSong) async {
  //   await audioPlayer
  //       .setAudioSource(AudioSource.uri(Uri.parse(curSong.uri.toString())));
  //   await audioPlayer.play();
  //   // await audioPlayer.pause();
  // }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  double durationinMilliSec(Duration? duration) {
    return duration != Duration.zero ? (duration?.inMilliseconds ?? 1) / 1 : 1;
  }

  @override
  Widget build(BuildContext context) {
    var _ctx = context.watch<AudioProvider>();
    var song = _ctx.currnetSong;
    // var song = Provider.of<AudioProvider>(context).currnetSong;
    var _positionDataStream = _ctx.positionDataStream;
    return Container(
      height: 72,
      color: Colors.redAccent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  PositionData? positionData = snapshot.data;
                  return LinearProgressIndicator(
                    value: (positionData?.position.inMilliseconds ?? 0) /
                        (durationinMilliSec(positionData?.duration)),
                    color: const Color.fromARGB(255, 40, 214, 130),
                    backgroundColor: Colors.white,
                    minHeight: 2,
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onTap!(),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: QueryArtworkWidget(
                              id: song.id,
                              type: ArtworkType.AUDIO,
                              artworkFit: BoxFit.cover,
                              keepOldArtwork: true,
                              artworkBorder: BorderRadius.circular(0),
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                                size: 200,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(song.title,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(width: 8, height: 8),
                                Text(
                                    (song.artist ?? '') +
                                        ' - ' +
                                        (song.album ?? ''),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                const PlayButton(large: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  final bool large;
  const PlayButton({Key? key, required this.large}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioProvider>(context);
    return Container(
      width: large ? double.infinity : 128,
      alignment: Alignment.center,
      height: large ? 70 : 50,
      child: large
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 上一首
                SizedBox(
                  width: 50,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.center,
                    onPressed: () {
                      if (player.player.hasPrevious) {
                        // player.player.stop();
                        player.player.seekToPrevious();
                        // player.player.play();
                      }
                    },
                    icon: const Icon(
                      Icons.skip_previous_rounded,
                      size: 50,
                    ),
                    color: player.player.hasPrevious
                        ? Colors.white
                        : const Color.fromARGB(100, 255, 255, 255),
                  ),
                ),
                // 暂停播放
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  width: 70,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      player.trigger();
                    },
                    icon: player.isPlaying
                        ? const Icon(
                            Icons.pause_circle_filled,
                            size: 70,
                          )
                        : const Icon(
                            Icons.play_circle_fill,
                            size: 70,
                          ),
                    color: Colors.white,
                  ),
                ),
                // 下一首
                SizedBox(
                  width: 50,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      if (player.player.hasNext) {
                        // player.player.stop();
                        player.player.seekToNext();
                        // player.player.play();
                      }
                    },
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      size: 50,
                    ),
                    color: player.player.hasNext
                        ? Colors.white
                        : const Color.fromARGB(100, 255, 255, 255),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: 42,
                  child: IconButton(
                    onPressed: () {
                      if (player.player.hasPrevious) {
                        // player.player.stop();
                        player.player.seekToPrevious();
                        // player.player.play();
                      }
                    },
                    icon: const Icon(Icons.skip_previous),
                    color: player.player.hasPrevious
                        ? Colors.white
                        : const Color.fromARGB(100, 255, 255, 255),
                  ),
                ),
                SizedBox(
                  width: 42,
                  child: IconButton(
                    onPressed: () {
                      player.trigger();
                    },
                    icon: player.isPlaying
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 42,
                  child: IconButton(
                    onPressed: () {
                      if (player.player.hasNext) {
                        // player.player.stop();
                        player.player.seekToNext();
                        // player.player.play();
                      }
                    },
                    icon: const Icon(Icons.skip_next),
                    color: player.player.hasNext
                        ? Colors.white
                        : const Color.fromARGB(100, 255, 255, 255),
                  ),
                ),
              ],
            ),
    );
  }
}
