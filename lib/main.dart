import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music/config/themes/app_theme.dart';
import 'package:flutter_music/providers/favorite_model.dart';
import 'package:flutter_music/providers/playlist_model.dart';
import 'package:flutter_music/routes/routes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("Favorites");

  await JustAudioBackground.init(
    androidNotificationIcon: 'drawable/ic_notification',
    notificationColor: const Color(0xFFE6E6E6),
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => AudioProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => FavoriteProvider(),
        ),
      ],
      child: const App(),
    ),
  );

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent);

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle); // 设置顶部状态栏背景透明
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'flutter_music',
      locale: const Locale('zh'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.basic,
      routerConfig: routes(),
    );
  }
}
