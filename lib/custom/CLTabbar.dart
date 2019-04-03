import 'package:flutter/material.dart';
import '../Home/CLHomePage.dart';
import '../MeiZi/CLMeiZiPage.dart';
import '../Profile/CLProfilePage.dart';
import '../Moments/CLMomentsPage.dart';

class CLTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '斗鱼直播',
      home: CLTabbar(),
      debugShowCheckedModeBanner: false,// 隐藏debug条幅
      theme: ThemeData( // 设置主题色
        primaryColor: Colors.blue,
        highlightColor: Color.fromRGBO(255, 255, 255, 0.5),
        splashColor: Colors.white70, /// 溅墨效果
      ),
    );
  }
}

class CLTabbar extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CLTabbar();
  }
}

class _CLTabbar extends State<CLTabbar> {
  final List<Widget> _children = [
    CLHomePage(title: '首页',),
    CLMeiZiPage(title: '美女'),
    CLMomentsPage(title: '朋友圈'),
    CLProfilePage(title: '我',),
  ];
  /// 当前选中的索引
  int _currentIndex = 0;
  /// 点击tabbar的回调
  void _onTapTabbarHandler(int index){
    setState(() { /// 设置当前索引
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( /// 使用IndexedStack存储界面,防止每次都重新加载数据
        children: _children,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar( //添加底部Tabbar
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        onTap: _onTapTabbarHandler, /// 点击回调
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页')
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            title: Text('美女')
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.disc_full),
            title: Text('朋友圈')
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('我')
          )
        ],
      ),
    );
  }
}