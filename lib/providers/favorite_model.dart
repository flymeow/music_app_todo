import 'package:flutter/material.dart';
import 'package:flutter_music/views/home/home.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider() {
    _loadFavSongs();
    logger.w("run init");
  }
  final Box _box = Hive.box("Favorites");
  late List<SongModel> _favSongs = [];

  List<SongModel> get favSongs => _favSongs;

  addToFav(SongModel song) {
    Map info = song.getMap;
    info['data_modified'] = DateTime.now().millisecondsSinceEpoch;
    _box.put(song.id, song.getMap);
    _loadFavSongs();
    notifyListeners();
  }

  removeFav(int id) {
    if (_box.containsKey(id)) _box.delete(id);
    _loadFavSongs();
    notifyListeners();
  }

  bool isInFav(int id) => _box.containsKey(id);

  _loadFavSongs() async {
    _favSongs = [];
    for (Map info in _box.values) {
      _favSongs.add(SongModel(info));
    }
    _favSongs.sort(
      (a, b) => a.dateModified!.compareTo(b.dateModified!),
    );
  }
}
