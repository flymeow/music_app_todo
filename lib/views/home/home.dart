import 'package:flutter/material.dart';
import 'package:flutter_music/common/permissions/permissions.dart';
import 'package:flutter_music/providers/playlist_model.dart';
import 'package:flutter_music/views/search/search.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:logger/logger.dart';

var logger = Logger();

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SongModel> totalSongs = <SongModel>[];
  int pageNum = 0;
  final OnAudioQuery _audioQuery = OnAudioQuery();

  bool permissionStatus = false;
  bool buttonClick = false;

  @override
  void initState() {
    super.initState();

    // slideController = context.read<AudioProvider>().slideController;

    // WidgetsBinding.instance.addObserver(this);

    // checkNecessaryPermissions(context);

    audioPermission().then((value) => {
          setState(() {
            permissionStatus = value;
          })
        });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed &&
  //       !permissionStatus &&
  //       buttonClick) {
  //     Permission.audio.request().then((value) => {
  //           setState(() {
  //             permissionStatus = value.isGranted;
  //             buttonClick = false;
  //           })
  //         });
  //   }

  //   if (state == AppLifecycleState.paused) {
  //     setState(() {
  //       buttonClick = true;
  //     });
  //   }
  // }

  _requestPermission() async {
    bool _permissionStatus = await audioPermission();
    if (!_permissionStatus) {
      openAppSettings();
    } else {
      setState(() {
        permissionStatus = _permissionStatus;
        buttonClick = false;
      });
    }
  }

  Future<List<SongModel>> getLoadSong() async {
    return totalSongs;
  }

  // 过滤非MP3格式
  Future<List<SongModel>> _querySong() async {
    List<SongModel> result = await _audioQuery
        .querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    )
        .then((value) {
      return value.where((element) => element.fileExtension == 'mp3').toList();
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        title: Column(
          children: [
            Container(
              height: 34,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100),
              child: Row(
                children: [
                  const SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(Icons.search,
                        size: 20.0, color: Color(0xFF999999)),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      cursorColor: Colors.grey,
                      autofocus: false, // 是否自动获取焦点
                      // focusNode: _focusNode, // 焦点控制
                      // controller: _controller,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '搜索',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                      textInputAction: TextInputAction.search,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Search()),
                        );
                      }, //widget.onTap,
                      // 输入框内容改变回调
                      onChanged: (value) {
                        logger.i("onchange event$value");
                      }, //widget.onChanged,
                      onSubmitted: (value) {
                        logger.i("submit event");
                      }, //widget.onSearch, //输入框完成触发
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: !permissionStatus
          ? Center(
              child: FilledButton(
                onPressed: () {
                  _requestPermission();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text("开启权限"),
              ),
            )
          : FutureBuilder<List<SongModel>>(
              future: _querySong(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                //no songs found
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No Songs Found"),
                  );
                }

                totalSongs.clear();
                totalSongs = snapshot.data!;

                List<SongModel> songs = snapshot.data!.sublist(0,
                    snapshot.data!.length >= 20 ? 20 : snapshot.data!.length);

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 0),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      // decoration: const BoxDecoration(color: Colors.grey),
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 12,
                        right: 12,
                        bottom: 5,
                      ),
                      child: Ink(
                        // decoration: const BoxDecoration(
                        //   color: Colors.amber,
                        //   borderRadius: BorderRadius.all(Radius.circular(12)),
                        // ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          // splashColor: const Color(0xFFF08080).withOpacity(0.4),
                          // hoverColor: const Color(0xFFF08080).withOpacity(0.4),
                          // focusColor: const Color(0xFFF08080).withOpacity(0.4),
                          highlightColor:
                              const Color(0xFFF5F5F5).withOpacity(0.9),
                          onTap: () {
                            // 关闭键盘
                            if (MediaQuery.of(context).viewInsets.bottom > 0) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }

                            var _context = context.read<AudioProvider>();

                            if (_context.currnetSong.toString() != '{}' &&
                                snapshot.data![index].toString() != '{}' &&
                                (_context.currnetSong.id ==
                                    snapshot.data![index].id)) {
                              // _context.setequal(true);
                            } else {
                              if (_context.player.playing) {
                                Provider.of<AudioProvider>(context,
                                        listen: false)
                                    .player
                                    .stop();
                              }
                              _context.playSongs(songs, initialIndex: index);
                            }

                            // GetSongs.audioPlayer.setAudioSource(
                            //     GetSongs.createSongList(item.data!),
                            //     initialIndex: index);

                            // // set ID
                            // context
                            //     .read<AudioProvider >()
                            //     .setId(snapshot.data![index].id, item.data![index]);
                            // // set play status
                            // context.read<AudioProvider >().setStatus('play');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              QueryArtworkWidget(
                                id: snapshot.data![index].id,
                                type: ArtworkType.AUDIO,
                                artworkWidth: 60,
                                artworkHeight: 60,
                                artworkFit: BoxFit.cover,
                                artworkBorder: BorderRadius.circular(12),
                                nullArtworkWidget: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    //color: const Color(0x15ffffff),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0x33ffffff),
                                        Color(0x33000000)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Color(0xFF5AB2FA),
                                    size: 24,
                                  ),
                                ),
                                keepOldArtwork: true,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Text(
                                        snapshot.data![index].title,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        left: 15,
                                      ),
                                      child: Text(
                                        (snapshot.data![index].artist ?? "") +
                                            " - " +
                                            (snapshot.data![index].album ?? ""),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    // slideController.dispose();
    super.dispose();
  }
}
