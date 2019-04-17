import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import '../custom/CLText.dart';
import '../custom/CLListViewRefresh.dart';
import '../Utils/CLUtil.dart';
import 'package:common_utils/common_utils.dart';
import '../Utils/CLDioUtil.dart';
import '../Model/CLCommentsModel.dart';
import '../custom/HUD.dart';
import '../custom/CLFlow.dart';
import 'package:flutter/services.dart';


class CLMomentsDetailPage extends StatefulWidget {
  final Widget child;

  CLMomentsDetailPage({Key key, this.child}): super(key: key);

  _CLMomentsDetailPageState createState() => _CLMomentsDetailPageState();
}

class _CLMomentsDetailPageState extends State<CLMomentsDetailPage> {

  bool isReply = false;
  String replyId = "";
  String _momentId = "";
  String _userId = "123456";
  CLCommentModel _commentModel;

  /// 接受客户端发送过来的数据
  EventChannel eventChannel = EventChannel("detailChannel");
  MethodChannel methodChannel = MethodChannel("detailMethodChannel");

  /// 发布评论
  _publishMomentComment() async{
    if (textEditingController.text.isEmpty) {
      HUD().showMessageHud(context,content: "文本不能为空");
      return;
    }
    Map<String,dynamic> params = {
      "user_id": _userId,
      "content": textEditingController.text,
      "moment_id": _momentId,
      "reply_user_id": replyId,
    };
    print("object == $params");

    HUD().showHud(context);
    CLResultModel result = await CLDioUtil().requestPost("http://api.cleven1.com/api/moments/addComments",params: params);
    if(result.success){
      HUD().hideHud();
      HUD().showMessageHud(context,content: "发送成功");
      _getMomentComentsData();
      setState(() {
        isReply = false;
      });
      replyId = "";
      textEditingController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }else{
      HUD().hideHud();
      HUD().showMessageHud(context,content: "发送失败");
    }
  }

  /// 获取评论数据
  _getMomentComentsData({bool isLoadMore = false,String lastCommentId = ""}) async{
    String url = "http://api.cleven1.com/api/moments/commentsInfo?isLoadMore=${isLoadMore ? "1" : "0"}&offset_id=$lastCommentId&moment_id=$_momentId";
    print(url);
    CLResultModel result = await CLDioUtil().requestGet(url);
    if(result.success){
        Map data = result.data["data"];
        CLCommentModel commentModel = CLCommentModel.fromJson(data);
        print("data === $data");
        print("model === ${commentModel.toJson()}");
      if (isLoadMore) {
        /// 把数据更新放到setState中会刷新页面
        List tempArray = _commentModel.comments;
        if (commentModel.comments.isEmpty == false || commentModel.comments.length <= 0) {
          tempArray.addAll(commentModel.comments);
        }
        commentModel.comments = tempArray;
        setState(() {
          _commentModel = commentModel;
        });
      }else{
        setState(() {
          _commentModel = commentModel;
        });
      }
    }else{
      HUD().showMessageHud(context,content: "获取失败");
    }
  }

  @override
  void initState() {
    super.initState();
    _reviceNativeParams();
  }

  /// 获取客户端传递过来的参数
  _reviceNativeParams() async {
    try {
      eventChannel.receiveBroadcastStream().listen((result){
        print("object == $result");
        _momentId = result["moment_id"];
        _userId = result["user_id"];
        _getMomentComentsData();
      });
    } on PlatformException catch (e) {
      print("event get data err: '${e.message}'.");
    }
  }

  
  @override
  void dispose() {
    FocusScope.of(context).requestFocus(FocusNode());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: CLAppBar(title: "详情",),
        body: _getListViewContainer(),
      ),
    );
  }

  _getHeaderContainer(CLCommentModel momentModel){
    return _getBaseContainer(
      momentModel, 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CLText(text: momentModel.content, maxLines: momentModel.isDidFullButton ? 10000 : 6, style: TextStyle(color: Colors.pink),),
          SizedBox(height: 10,),
          momentModel.isShowFullButton ? GestureDetector(
          onTap: (){
            setState(() {
              momentModel.isDidFullButton = !momentModel.isDidFullButton;
            });
          },
          child: CLText(text: momentModel.isDidFullButton == true ? "收起" : "全文",style: TextStyle(color: Colors.blue),),) : Container(),
          SizedBox(height: 10,),
          momentModel.momentType == "1" ? CLFlow(
            count: momentModel.momentPics.length,
            children: _getImageContaniner(momentModel),
          ) : Container()
        ],
      ),
      subChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          CLText(text: "留言板",style: setTextStyle(fontWeight: true,fontSize: 15),),
          SizedBox(height: 10,),
        ],
      )
      );
  }


  _getImageContaniner(model) {
    List<GestureDetector> images = [];
    List<String> pics = [];
    for (var i = 0; i < model.momentPics.length; i++) {
      String imageUrl = model.momentPics[i];
      pics.add(imageUrl);
      images.add(GestureDetector(
        onTap: (){
          // print("imageUrl == $imageUrl index == $i");
          methodChannel.invokeMethod("photoBrowser",{
            "index": i,
            "pics": pics
          });
          // CLPushUtil().pushNavigatiton(context, CLPhotoViewBrowser(pics: pics, currentIndex: i,));
        },
        child: ExtendedImage.network(imageUrl,cache: true,fit: BoxFit.cover,),
      ));
    }
    return images;
  }

  _getListViewContainer(){
    List listData = [];
    int count = 0;
    if (_commentModel == null){
      listData = [];
    }else if(_commentModel.comments.isEmpty || _commentModel.comments.length <= 0){
      count = 1;
      listData = [1];
    }else{
      listData = _commentModel.comments;
      count = _commentModel.comments.length + 1;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: NotificationListener(
            onNotification: (ScrollNotification note) {
              print(note.metrics.pixels.toInt());  // 滚动位置。
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: CLListViewRefresh(
            listData: listData,
            child: ListView.builder(
                itemCount: count,
                itemBuilder: (context,index) {
                  if (index == 0) {
                  return _getHeaderContainer(_commentModel);
                  }
                  CLCommentsDetailModel commentsModel = _commentModel.comments[index - 1];
                  return _getListViewItemContainer(commentsModel);
                },
              ),
            onRefresh: (){
              _getMomentComentsData();
            },
            loadMore: (){
              if (_commentModel.comments.isEmpty == false || _commentModel.comments.length > 0){
                CLCommentsDetailModel commentsModel = _commentModel.comments.last;
                _getMomentComentsData(isLoadMore: true,lastCommentId: commentsModel.momentId); 
              }
            },
          ),
          ),
        ),
        _getTextFieldContainer(),
        SizedBox(height: 10,)
      ],
    );
  }

  TextEditingController textEditingController = TextEditingController();
  FocusNode _focusNode = new FocusNode();
  _getTextFieldContainer(){
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: textEditingController,
            focusNode: _focusNode,
            maxLines: 1,
            maxLength: 100,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: isReply ? "回复: " : "留言:",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none
            ),
            onSubmitted: (text){
              /// 隐藏键盘
              FocusScope.of(context).requestFocus(FocusNode());
            },
        ),
        ),
        FlatButton(
          child: CLText(text: "发送",style: TextStyle(color: Colors.redAccent),),
          onPressed: (){
            _publishMomentComment();
          },
        )
      ],
    );
  }

  _getListViewItemContainer(CLCommentsDetailModel commentsModel){
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(_focusNode);
        setState(() {
          replyId = commentsModel.userInfo.userId;
          isReply = true;
        });
      },
      child: _getBaseContainer(
      commentsModel,
      RichText(
        text: TextSpan(
          text: commentsModel.replyUserInfo == null ? commentsModel.content : "回复",
          style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: commentsModel.replyUserInfo == null ? "" : "@${commentsModel.replyUserName}:",
              style: TextStyle(color: Colors.red)
            ),
            TextSpan(
              text: commentsModel.replyUserInfo == null ? "" : " ${commentsModel.content}",
              style: TextStyle(color: Colors.black)
            )
          ]
        ),
      ),
       nameColor: Colors.blueAccent,
       subChild: Column(
          children: <Widget>[
            SizedBox(height: 5,),
            Divider(height: 1.0,),
          ],
        ),
      name: commentsModel.replyUserName == null ? "" : commentsModel.aliasName
       ),
    );

  }

   _getBaseContainer(var model, Widget child ,{Widget subChild, Color nameColor, String name = ""}) {
    int timeStamp = model.timeStamp == null ? CLUtil.currentTimeMillis() : int.parse(model.timeStamp);    
    String formatTime = TimelineUtil.format(timeStamp,dayFormat: DayFormat.Simple);
    String avatarUrl = model.avatarUrl == null ? model.userInfo.avatarUrl : model.avatarUrl;
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ExtendedImage.network(
                avatarUrl,
                width: 40,
                height: 40,
                shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(20),
                cache: true,
              ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CLText(text: name.isEmpty ? model.aliasName : name,style: setTextStyle(textColor: nameColor == null ? Colors.black87 : nameColor),),
              CLText(text: formatTime,style: setTextStyle(textColor: Colors.grey,fontSize: 12),),
              SizedBox(height: 5,),
              child,
            ],
          ),
        ),
      ],
    ),
    subChild == null ? Container() : subChild
      ],
    ),
    );
  }

}

