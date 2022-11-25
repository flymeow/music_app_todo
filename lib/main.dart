import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music/config/themes/app_theme.dart';

import 'launch_page.dart';


void main() {
  runApp(const App());

  if(Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      theme: AppTheme.basic,
      title: "flutter_music",
      locale: const Locale('zh'),
        debugShowCheckedModeBanner: true,
      home: const LaunchPage()
    );
  }
}
