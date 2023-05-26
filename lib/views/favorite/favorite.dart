import 'package:flutter/material.dart';
import 'package:flutter_music/providers/favorite_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    var _ctx = Provider.of<FavoriteProvider>(context);
    List<SongModel> favSongs = _ctx.favSongs;

    return Scaffold(
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: favSongs.length,
        itemBuilder: (context, index) {
          final song = favSongs[index];
          return ListTile(
            title: Text(song.title),
          );
        },
      ),
    );
  }
}
