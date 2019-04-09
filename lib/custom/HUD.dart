import 'package:xs_progress_hud/xs_progress_hud.dart';
import 'package:flutter/material.dart';

class HUD {

  showHud(BuildContext context) async{
    XsProgressHud.show(context);
  }

  hideHud(){
    XsProgressHud.hide();
    // Future.delayed(Duration(milliseconds: 1500)).then((val) {
      
    // });
  }
  
   Future<void> showMessageHud(BuildContext context,{String content}) async {
    XsProgressHud.showMessage(context, content);
  }


}