import 'package:flutter/material.dart';
import '../custom/HUD.dart';

enum CLOptionType {
  delete,
  report
}
/// 定义回调类型
typedef Future<void> OnClickItemCallback(CLOptionType optionType);

class CLOptionPage extends PopupRoute {

  static CLOptionPage _currentOption;
  Duration delayed = Duration(milliseconds: 2000);
  OnClickItemCallback clickItemCallback;

  static showView(BuildContext context,{OnClickItemCallback clickItemCallback}) async{
    
    try {
      if (_currentOption != null) {
        _currentOption.navigator.pop();
      }
      CLOptionPage optionPage = CLOptionPage();
      optionPage.clickItemCallback = clickItemCallback;
      _currentOption = optionPage;
      Navigator.push(context, optionPage);
    } catch (e) {
      _currentOption = null;
    }

  }

  static hiddenView() async{
    _currentOption.navigator.pop();
    _currentOption = null;
  }

  @override
  // TODO: implement barrierColor
  Color get barrierColor => null;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => null;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => kThemeAnimationDuration;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {

    return GestureDetector(
      onTap: (){
        hiddenView();
      },
      child: Container(
        color: Color.fromRGBO(0, 0, 0, 0.4),
        child: Container(
          color: Colors.black38,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(color: Colors.black38,),
              ),
              Container(
                color: Colors.white,
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: FlatButton(
                          onPressed: (){
                            clickItemCallback(CLOptionType.delete);
                          },
                          child: Text("删除",style: TextStyle(color: Colors.black,fontSize: 18, decoration: TextDecoration.none),),
                        ))
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Center(child: FlatButton(
                          onPressed: (){
                            clickItemCallback(CLOptionType.report);
                            hiddenView();
                            HUD().showMessageHud(context,content: "举报成功");   
                          },
                          child: Text("举报",style: TextStyle(color: Colors.black,fontSize: 18, decoration: TextDecoration.none),),
                        )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }
}