import 'package:flutter/material.dart';


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


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

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
      body: Container(
        decoration: const BoxDecoration(color: Color(0xffffffff)),
        child:  const Text(
              "home page",
              style: TextStyle(color: Color(0xffde4242))
        ),
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

