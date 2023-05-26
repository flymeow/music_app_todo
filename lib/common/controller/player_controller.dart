import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController {
  final AudioPlayer player = AudioPlayer();

  late ConcatenatingAudioSource playlist;
  int _currentIndex = -1;
  List<SongModel> songsCopy = [];
  List<SongModel> playingSongs = [];

  int get currentIndex => _currentIndex;

  playSongs(
    List<SongModel> songs, {
    initialIndex = 0,
  }) {
    _currentIndex = initialIndex;
    playlist = createPlaylist(songs);
    player.setAudioSource(playlist, initialIndex: initialIndex);
    player.androidAudioSessionId;
    player.play();
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> audioSource = [];
    for (SongModel song in songs) {
      audioSource.add(AudioSource.uri(
        // Uri.parse(song.uri!),
        // tag: MediaItem(
        //   id: '${song.id}',
        //   album: '${song.album}',
        //   title: song.title,
        //   artUri: Uri.parse(
        //       'content://media/external/audio/media/${song.id}/albumart'),
        // ),
        Uri.parse(song.uri!),
        tag: MediaItem(
          id: song.id.toString(),
          title: song.title,
          album: song.album,
          artist: song.artist,
        ),
      ));
    }
    return ConcatenatingAudioSource(children: audioSource);
  }
}
