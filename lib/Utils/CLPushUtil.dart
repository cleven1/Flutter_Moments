import 'package:flutter/material.dart';

class CLPushUtil {
  
  pushNavigatiton(BuildContext context, Widget target){
    Navigator.push(
          context,
          new PageRouteBuilder(pageBuilder: (BuildContext context,
              Animation<double> animation, Animation<double> secondaryAnimation) {
            // 跳转的路由对象
            return target;
          }, transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return _createTransition(animation, child);
          }));
  }
  

  SlideTransition _createTransition(Animation<double> animation, Widget child) {
    return new SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(animation),
      child: child,
    );
  }
}