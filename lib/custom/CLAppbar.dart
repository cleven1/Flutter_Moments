import 'package:flutter/material.dart';

class CLAppBar extends PreferredSize {

  final Widget child;
  final String title;
  final Widget leading;
  final List<Widget> actions;
  static final double navHeight = 44;

  CLAppBar({Key key, @required this.child, this.title, this.leading, this.actions}) : super(key: key, child:child, preferredSize: Size.fromHeight(navHeight));

  @override
  PreferredSize build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(navHeight),
      child: AppBar(
        iconTheme: IconThemeData(color: Colors.black54,size: 15.0),
        textTheme: TextTheme(title: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),),
        backgroundColor: Colors.white,
        title: Text('$title',),
          centerTitle: true, /// 标题居中
          /// 设置状态栏颜色
          brightness: Brightness.light, 
          /// 设置导航栏阴影效果
          elevation: 0.0,
          /// 左侧按钮
          leading: leading,
          /// 右侧按钮
          actions: actions
      ),
    );
  }
}