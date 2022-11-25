
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColorLight = Color.fromRGBO(217,223,253,1);
  static const Color primaryColor = Color.fromARGB(94, 119, 251, 1);

  static ThemeData get basic {
    return ThemeData(
      primarySwatch: Colors.indigo,
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      elevatedButtonTheme: ElevatedButtonThemeData(
        // 文字颜色
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if(states.contains(MaterialState.disabled)) {
              return Colors.white;
            } else {
              return null;
            }
          }),
          // 背景色
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if(states.contains(MaterialState.disabled)) {
              return const Color(0xffee0a24).withOpacity(0.5);
            } else {
              return Colors.red;
            }
          }),

        )
      ),
      // 取消水波纹
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      // 文字颜色
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Color(0xff7b7b7b),
        )
      ),
      tabBarTheme: const TabBarTheme(
        unselectedLabelColor: Color(0xff7b7b7b),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontSize: 18,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xfffbfbfb),
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 200,
        backgroundColor: Color(0xfffbfbfb),
        selectedItemColor: Color(0xff464646),
        unselectedItemColor: Color(0xff7b7b7b),
        selectedLabelStyle: TextStyle(
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
        )
      ),
    );
  }
}