import 'package:flutter/material.dart';

// 导航
const List<Map> _bottomBarList = [
  {
    "icon": Icon(Icons.home_rounded),
    "active": Icon(
      Icons.home_rounded,
      color: Colors.redAccent,
    ),
    "label": "首页",
  },
  {
    "icon": Icon(Icons.favorite),
    "active": Icon(
      Icons.favorite,
      color: Colors.redAccent,
    ),
    "label": "收藏",
  },
  {
    "icon": Icon(Icons.account_circle_rounded),
    "active": Icon(
      Icons.account_circle_rounded,
      color: Colors.redAccent,
    ),
    "label": "我的",
  },
];

// 底部导航
List<BottomNavigationBarItem> _bottomNavigationBarItems() {
  return _bottomBarList.map((item) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 3.0),
        child: item["icon"],
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 2.0),
        child: item["active"],
      ),
      label: item["label"],
      tooltip: "",
    );
  }).toList();
}

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key, required this.active, required this.onChange})
      : super(key: key);

  final int active;
  final void Function(int value) onChange;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  void _onTabBarTap(int index) {
    widget.onChange(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _bottomNavigationBarItems(),
      currentIndex: widget.active,
      onTap: _onTabBarTap,
    );
  }
}
