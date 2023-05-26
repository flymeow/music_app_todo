import 'package:flutter/material.dart';
import 'package:flutter_music/providers/favorite_model.dart';
import 'package:flutter_music/views/home/home.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({Key? key, required this.song}) : super(key: key);
  final SongModel song;
  @override
  Widget build(BuildContext context) {
    var _ctx = Provider.of<FavoriteProvider>(context);
    bool isFav = _ctx.isInFav(song.id);
    return IconButton(
      onPressed: () {
        if (isFav) {
          _ctx.removeFav(song.id);
        } else {
          _ctx.addToFav(song);
        }
      },
      icon: Icon(
        Icons.favorite,
        color: isFav ? Colors.red : Colors.white,
      ),
    );
  }
}
