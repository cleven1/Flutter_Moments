import 'package:flutter/material.dart';
import 'dart:ui';
import '../custom/CLAppbar.dart';
import '../custom/CLText.dart';
// import 'package:photo/photo.dart';
// import 'package:photo_manager/photo_manager.dart';
import '../Utils/CLDioUtil.dart';
import '../custom/CLPhotoView.dart';
import '../custom/HUD.dart';

/// 定义回调类型
typedef Future<void> PubilshMomentsSuccess();

class CLPublishMomentPage extends StatefulWidget {
  final Widget child;
  final String title;
  final PubilshMomentsSuccess pubilshMomentsSuccess;

  CLPublishMomentPage({Key key, this.child, @required this.title, this.pubilshMomentsSuccess}): super(key: key);

  _CLPublishMomentPageState createState() => _CLPublishMomentPageState();
}

class _CLPublishMomentPageState extends State<CLPublishMomentPage> {

  // List<AssetEntity> imageList = [];

  String _content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CLAppBar(
        title: widget.title,
        actions: _getRightActions(),
      ),
      body: _getPublishContainer(),
    );
  }

  @override
  void dispose() {
    FocusScope.of(context).requestFocus(FocusNode());
    super.dispose();
  }

  /// 发布
  _publishMoment() async{
    print("content == $_content");
    
    if (_content.isEmpty) {
      HUD().showMessageHud(context,content: "内容不能为空");
      return;
    }
    Map<String,dynamic> params = {
      "content": _content,
      "user_id": "123456",
      "moment_pics": [],
      "moment_type": "0"
    };
    HUD().showHud(context);
    CLResultModel result = await  CLDioUtil().requestPost("http://api.cleven1.com/api/moments/publishMoments",params: params);
    if(result.success){
      print(result.data);
      widget.pubilshMomentsSuccess();
      Navigator.pop(context);
      HUD().hideHud();
    }else{
      print("发布失败== ${result.data}");
      HUD().hideHud();
      HUD().showMessageHud(context,content: "发布失败");
    }
  }

  _getRightActions() {
    return <Widget>[
          Container(
            width: 65,
            child: FlatButton(child: CLText(text: "发布",style: TextStyle(
              color: Colors.orangeAccent
            ),),
            onPressed: (){
              print("发布");
              _publishMoment();
            },),
          )
        ];
  }

  _getAddPhotoContainer() {
    return Container(
            height: 80,
            width: 80,
            child: RaisedButton(child: Icon(Icons.add_to_photos),onPressed: () {

              print('选择照片');
              // _photoListParams();
            },),
          );
  }

  _getPublishContainer() {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _getTextFieldContainer(),
          ),
          SizedBox(height: 50,),
          // imageList.length > 0 ? CLPhotoView(list: imageList,
          // onDeleteItem: (list) {
          //     setState(() {
          //       imageList = list;
          //     });
          // },) : _getAddPhotoContainer(),
          SizedBox(height: 11,)

        ],
      ),


    );
  }

  _getTextFieldContainer(){
    return TextField(
      maxLines: 100,
      maxLength: 500,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: "请输入文本:",
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none
      ),
      onChanged: (text){
        _content = text;
      },
      onSubmitted: (text){
        /// 隐藏键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  // void _photoListParams() async {
  //     var assetPathList = await PhotoManager.getImageAsset();
  //     _pickAsset(PickType.onlyImage, pathList: assetPathList);
  //   }

  // void _pickAsset(PickType type, {List<AssetPathEntity> pathList}) async {
    
  //   List<AssetEntity> imgList = await PhotoPicker.pickAsset(
  //     context: context,
  //     // BuildContext requied

  //     /// The following are optional parameters.
  //     themeColor: Colors.blue,
  //     // the title color and bottom color
  //     padding: 3.0,
  //     // item padding
  //     dividerColor: Colors.white,
  //     // divider color
  //     disableColor: Colors.grey.shade300,
  //     // the check box disable color
  //     itemRadio: 0.88,
  //     // the content item radio
  //     maxSelected: 9,
  //     // max picker image count
  //     provider: I18nProvider.chinese,
  //     // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
  //     rowCount: 5,
  //     // item row count
  //     textColor: Colors.white,
  //     // text color
  //     thumbSize: 150,
  //     // preview thumb size , default is 64
  //     sortDelegate: SortDelegate.common,
  //     // default is common ,or you make custom delegate to sort your gallery
  //     checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
  //       activeColor: Colors.white,
  //       unselectedColor: Colors.white,
  //     ), // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox

  //     // loadingDelegate: this, // if you want to build custom loading widget,extends LoadingDelegate [see example/lib/main.dart]

  //     badgeDelegate: const DefaultBadgeDelegate(), /// or custom class extends [BadgeDelegate]

  //     pickType: type, // all/image/video

  //     photoPathList: pathList,
  //   );
  //     String currentSelected = '';
  //     if (imgList == null) {
  //       currentSelected = "not select item";
  //     } else {
  //       /// 图片路径
  //       List<String> r = [];
  //       for (var e in imgList) {
  //         var file = await e.file;
  //         r.add(file.absolute.path);
  //       }
  //       currentSelected = r.join("\n\n");
  //       print(currentSelected);

  //       print(imgList[0].file.toString());
  //       print(imgList[0].originFile.toString());
  //       print(imgList[0].fullData);
        

  //       setState(() {
  //         imageList = imgList;
  //       });
  //     }
      
  // }
}