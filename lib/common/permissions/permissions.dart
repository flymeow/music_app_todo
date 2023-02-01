import 'dart:developer';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  /*
  denied, //没授权默认是这个，也保不准特殊情况是表示拒绝的，最好是先请求权限后用于判断
  granted, //正常使用
  restricted, //被操作系统拒绝，例如家长控制等
  limited, //被限制了部分功能，适用于部分权限，例如相册的
  permanentlyDenied, //这个权限表示永久拒绝，不显示弹窗，用户可以手动调节（也有可能是系统关闭了该权限导致的）
*/

  static Permissions instance  = Permissions();
  late PermissionStatus _permissionStatus = PermissionStatus.granted;

  bool get granted => _permissionStatus == PermissionStatus.granted;

  bool get notGranted => !granted;

  Future<void> init() async {
    _permissionStatus = await Permission.storage.status;
  }

  Future<bool> req() async {
    _permissionStatus = await Permission.storage.request();
    if(_permissionStatus == PermissionStatus.granted) {
      log("已经获取存储权限");
      return true;
    } else if(_permissionStatus == PermissionStatus.permanentlyDenied) {
      log("运行手动访问");
      return false;
      // Allow access to storage manually
    } else if(_permissionStatus == PermissionStatus.denied) {
      log("拒绝授权");
      return false;
    }
    return false;
  }

}