import 'package:flutter/material.dart';
import 'package:flutter_music/utils/utils.dart';

class AppTheme {
  static const Color primaryColorLight = Color.fromARGB(255, 19, 51, 207);
  static const Color primaryColor = Color.fromARGB(255, 8, 34, 44);

  static ThemeData get basic {
    return ThemeData(
      // brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      elevatedButtonTheme: ElevatedButtonThemeData(
        // 文字颜色
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.white;
            } else {
              return null;
            }
          }),
          // 背景色
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return const Color.fromARGB(255, 167, 166, 166)
                    .withOpacity(0.5);
              } else {
                return Colors.white;
              }
            },
          ),
        ),
      ),
      // 取消水波纹
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      // 文字颜色
      textTheme: const TextTheme(
          bodyMedium: TextStyle(
        color: Color(0xff7b7b7b),
      )),
      tabBarTheme: const TabBarTheme(
        unselectedLabelColor: Color(0xff7b7b7b),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontSize: 18,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 200,
          backgroundColor: Color(0xfffbfbfb),
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Color.fromARGB(255, 165, 165, 165),
          selectedLabelStyle: TextStyle(
            fontSize: 9,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 9,
          )),
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Utils.createMaterialColor(
                  const Color.fromARGB(255, 255, 255, 255)))
          .copyWith(background: Colors.white),
    );
  }
}
