import 'dart:developer';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Permissions instance  = Permissions();
  late PermissionStatus _permissionStatus;

  bool get granted => _permissionStatus == PermissionStatus.granted;

  bool get notGranted => !granted;

  Future<void> init() async {
    _permissionStatus = await Permission.storage.status;
  }

  Future<void> req() async {
    _permissionStatus = await Permission.storage.request();
    if(_permissionStatus == PermissionStatus.granted) {
      log("已经获取存储权限");
    } else if(_permissionStatus == PermissionStatus.permanentlyDenied) {
      log("运行手动访问");
      // Allow access to storage manually
    }
  }

}