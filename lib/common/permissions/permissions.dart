import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_music/views/home/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
/*
  denied, //没授权默认是这个，也保不准特殊情况是表示拒绝的，最好是先请求权限后用于判断
  granted, //正常使用
  restricted, //被操作系统拒绝，例如家长控制等
  limited, //被限制了部分功能，适用于部分权限，例如相册的
  permanentlyDenied, //这个权限表示永久拒绝，不显示弹窗，用户可以手动调节（也有可能是系统关闭了该权限导致的）
*/

Future<bool> storagePermisseion() async {
  return await Permission.storage.request().isGranted;
}

Future<bool> audioPermission() async {
  return await Permission.audio.request().isGranted;
}

Future<bool> checkNecessaryPermissions(BuildContext context) async {
  var _a = await Permission.audio.request();
  await Permission.notification.request();
  try {
    await Permission.storage.request();
  } catch (e) {
    Fluttertoast.showToast(
      msg: '$e',
    );
  }
  return _a.isGranted;
}
