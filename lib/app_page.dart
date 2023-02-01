import 'package:flutter/material.dart';
import 'package:flutter_music/views/account.dart';
import 'package:flutter_music/views/collect.dart';
import 'package:flutter_music/views/home.dart';


// 导航
const List<Map> _bottomBarList = [
  {
    "icon": "assets/images/icons/home.png",
    "active": "assets/images/icons/home_active.png",
    "label": "首页",
  },
  {
    "icon": "assets/images/icons/cloud.png",
    "active": "assets/images/icons/cloud_active.png",
    "label": "收藏",
  },
  {
    "icon": "assets/images/icons/account.png",
    "active": "assets/images/icons/account_active.png",
    "label": "我的",
  },
];


class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _HomeState();
}

class _HomeState extends State<AppPage> {
  int _currentIndex = 0;

  final List<Widget> _pageList = [
    const Home(),
    const Collect(),
    const Account()
  ];


  void _onTabBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBarItems(),
        currentIndex: _currentIndex,
        onTap: _onTabBarTap,
      ),
    );
  }
}

// 底部导航
List<BottomNavigationBarItem> _bottomNavigationBarItems() {
  return _bottomBarList.map((item) {
    return BottomNavigationBarItem(
      icon: Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 2.0), child: Image.asset(
        item["icon"],
        width: 16,
        height: 16,
      ),),
      activeIcon: Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 2.0), child: Image.asset(
        item["active"],
        width: 16,
        height: 16,
      ),),
      label: item["label"],
      tooltip: "",
    );
  }).toList();
}

