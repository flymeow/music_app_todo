import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music/app_page.dart';
import 'package:flutter_music/views/home.dart';

/*
* @启动页
* */
class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  late Timer _timer;
  int currentTime = 5;

  // 初始化state
  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        currentTime--;
      });
      if (currentTime < 1) {
        jumpHandler();
      }
    });
  }

  // 倒计时后跳转
  void jumpHandler() {
    _timer.cancel();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext content) => const AppPage()),
        (route) => false);
  }

  // 跳转浮动按钮
  Widget _clipButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 85,
        height: 26,
        color: Colors.black38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '跳过广告  ${currentTime < 1 ? 1 : currentTime}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xfffc4850)),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: const Text("音乐的力量",
                      style: TextStyle(color: Color(0xffffffff))),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 10,
            right: 10,
            child: InkWell(
              child: _clipButton(),
              onTap: jumpHandler,
            ))
      ],
    ));
  }
}
