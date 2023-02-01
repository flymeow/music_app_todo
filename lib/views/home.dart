import 'package:flutter/material.dart';
import 'package:flutter_music/common/permissions/permissions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<SongModel> totalSongs = <SongModel>[];
  int pageNum = 0;

  // final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getLocalSongs();

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     setState(() {
    //       pageNum++;
    //     });
    //     print("到底了$pageNum");
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Future<void> _handlePermissions() async {
  //    await Permissions.instance.req();
  //    var list = await _audioQuery.querySongs();
  //    LogUtil.e(list);
  // }

  Future<void> getLocalSongs() async {
    if (await Permissions.instance.req()) {
      var localSongs = await _audioQuery.querySongs(
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      setState(() {
        totalSongs = localSongs;
      });
    }
  }

  Future<List<SongModel>> getLoadSong() async {
    return totalSongs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SongModel>>(
        //default values
        future: _audioQuery.querySongs(
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //no songs found
          if (item.data!.isEmpty) {
            return const Center(
              child: Text("No Songs Found"),
            );
          }

          totalSongs.clear();
          totalSongs = item.data!;

          return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 15,
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      splashColor: const Color(0xFFF08080).withOpacity(0.4),
                      hoverColor: const Color(0xFFF08080).withOpacity(0.4),
                      focusColor: const Color(0xFFF08080).withOpacity(0.4),
                      highlightColor: const Color(0xFFFF3300).withOpacity(0.9),
                      onTap: () {
                        print(item.data![index].displayName);
                        // playSong(song);
                        // Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QueryArtworkWidget(
                            id: item.data![index].id,
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
                                    item.data![index].title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
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
              });
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SizedBox(
  //       height: 200,
  //       child: Column(
  //         children: [
  //           const Padding(padding: EdgeInsets.only(top: 40)),
  //           FutureBuilder<List<SongModel>>(
  //             future: getLoadSong(),
  //             builder: (context, data) {
  //               if (data.data == null) {
  //                 return const Center(child: CircularProgressIndicator());
  //               }
  //
  //               if (data.data!.isEmpty) {
  //                 return const Text("No Songs Found");
  //               }
  //
  //               return ListView.builder(
  //                 physics: const BouncingScrollPhysics(),
  //                 addAutomaticKeepAlives: false,
  //                 itemCount: (data as dynamic).data.length as int,
  //                 itemBuilder: (BuildContext context, int index) {
  //                   final song = {
  //                     'id': index,
  //                     'title': (data as dynamic).data[index].displayName,
  //                     'songId': (data as dynamic).data[index].id,
  //                     'songUrl': (data as dynamic).data[index].data
  //                   };
  //                   return Container(
  //                     padding: const EdgeInsets.only(
  //                       left: 12,
  //                       right: 12,
  //                       bottom: 15,
  //                     ),
  //                     child: InkWell(
  //                       borderRadius: BorderRadius.circular(20),
  //                       splashColor: const Color(0xFFF08080).withOpacity(0.4),
  //                       hoverColor: const Color(0xFFF08080).withOpacity(0.4),
  //                       focusColor: const Color(0xFFF08080).withOpacity(0.4),
  //                       highlightColor:
  //                           const Color(0xFFF08080).withOpacity(0.4),
  //                       onTap: () {
  //                         // playSong(song);
  //                         // Navigator.pushReplacementNamed(context, '/');
  //                       },
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           QueryArtworkWidget(
  //                             id: song['songId'] as int,
  //                             type: ArtworkType.AUDIO,
  //                             artworkWidth: 60,
  //                             artworkHeight: 60,
  //                             artworkFit: BoxFit.cover,
  //                             artworkBorder: BorderRadius.circular(8),
  //                             nullArtworkWidget: Container(
  //                               width: 50,
  //                               height: 50,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(7),
  //                                 //color: const Color(0x15ffffff),
  //                                 gradient: const LinearGradient(
  //                                   colors: [
  //                                     Color(0x33ffffff),
  //                                     Color(0x33000000)
  //                                   ],
  //                                   begin: Alignment.topLeft,
  //                                   end: Alignment.bottomCenter,
  //                                 ),
  //                               ),
  //                               child: const Icon(
  //                                 Icons.music_note,
  //                                 color: Color(0xFF5AB2FA),
  //                               ),
  //                             ),
  //                             keepOldArtwork: true,
  //                           ),
  //                           Flexible(
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: <Widget>[
  //                                 Container(
  //                                   alignment: Alignment.centerLeft,
  //                                   padding: const EdgeInsets.only(
  //                                     left: 15,
  //                                   ),
  //                                   child: Text(
  //                                     song['title'].toString(),
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: const TextStyle(
  //                                       color: Colors.black,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
