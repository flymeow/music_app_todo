import 'package:flutter/cupertino.dart';
import 'package:flutter_music/common/common.dart';
import 'package:flutter_music/views/home/home.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;

class AudioProvider extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  late ConcatenatingAudioSource playlist;
  bool _showMiniPlayer = false;
  SongModel _currentSong = SongModel({});
  List<SongModel> songQueue = [];

  int _currentIndex = -1;

  int get currentIndex => _currentIndex;
  bool get showMiniPlayer => _showMiniPlayer;
  bool get isPlaying => player.playing;

  SongModel get currnetSong => _currentSong;

  AudioProvider() {
    playlist = ConcatenatingAudioSource(children: []);

    player.currentIndexStream.listen((index) {
      if (index != null) {
        _currentIndex = index;
        _currentSong = songQueue.elementAt(_currentIndex);
        notifyListeners();
      }
    });

    player.sequenceStateStream.listen((event) {
      if (event != null && songQueue[event.currentIndex].id != currnetSong.id) {
        // logger.w(songQueue[event.currentIndex].id);
      }
    });
  }

  playSongs(List<SongModel> songs, {initialIndex = 0, showPanel = true}) {
    songQueue = [...songs]; //
    _showMiniPlayer = true;
    playlist = createPlaylist(songs);
    _currentSong = songQueue.elementAt(initialIndex);
    player.setAudioSource(playlist, initialIndex: initialIndex);
    player.androidAudioSessionId;
    player.play();
    notifyListeners();
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> audioSource = [];
    for (SongModel song in songs) {
      audioSource.add(AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: '${song.id}',
          album: '${song.album}',
          title: song.title,
          artUri: Uri.parse(
              'content://media/external/audio/media/${song.id}/albumart'),
          artist: song.artist,
        ),
      ));
    }
    return ConcatenatingAudioSource(children: audioSource);
  }

  void pauseFunc() {
    logger.i("暂停");
    player.pause();
    notifyListeners();
  }

  void playFunc() {
    logger.i("播放");
    player.play();
    notifyListeners();
  }

  void trigger() {
    if (player.playing) {
      logger.i("暂停");
      player.pause();
    } else {
      logger.i("播放");
      player.play();
    }
    notifyListeners();
  }

  Stream<PositionData> get positionDataStream =>
      rx_dart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );
}
