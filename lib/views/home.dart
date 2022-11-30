import 'package:flutter/material.dart';
import 'package:flutter_music/common/permissions/permissions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<void> _handlePermissions() async {
     await Permissions.instance.req();
  }

  @override
  Widget build(BuildContext context) {
    bool status = Permissions.instance.granted;
    print("home page $status");
    return  Container( child: ElevatedButton(
      child:  Text("grand"),
      onPressed: _handlePermissions,
    ),);
  }
}
