import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import '../custom/CLText.dart';
import '../custom/CLListViewRefresh.dart';
import '../custom/CLAppbar.dart';
import '../Model/CLMomentsModel.dart';
import '../Utils/CLUtil.dart';
import 'package:common_utils/common_utils.dart';
import '../Utils/CLDioUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Model/CLCommentsModel.dart';
import '../custom/HUD.dart';
import '../custom/CLFlow.dart';
import '../Utils/CLPushUtil.dart';
import './CLPhotoViewBrowser.dart';


class CLMomentsDetailPage extends StatefulWidget {
  final Widget child;
  final CLMomentsModel momentModel;

  CLMomentsDetailPage({Key key, this.child ,@required this.momentModel}): super(key: key);

  _CLMomentsDetailPageState createState() => _CLMomentsDetailPageState();
}

class _CLMomentsDetailPageState extends State<CLMomentsDetailPage> {

  bool isReply = false;
  String replyId = "";
  List<CLCommentsModel> commentList = [];

  /// 发布评论
  _publishMomentComment() async{
    if (textEditingController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "文本不能为空",
        gravity: ToastGravity.CENTER
      );
      return;
    }
    Map<String,dynamic> params = {
      "user_id": "123456",
      "content": textEditingController.text,
      "moment_id": widget.momentModel.momentId,
      "reply_id": replyId,
    };
    print("object == $params");

    HUD().showHud(context);
    CLResultModel result = await CLDioUtil().requestPost("http://api.cleven1.com/api/moments/addComments",params: params);
    if(result.success){
      HUD().hideHud();
      Fluttertoast.showToast(
        msg: "发送成功",
        gravity: ToastGravity.CENTER
      );
      _getMomentComentsData();
      setState(() {
        isReply = false;
      });
      replyId = "";
      textEditingController.clear();
      FocusScope.of(context).requestFocus(FocusNode());
    }else{
      HUD().hideHud();
      Fluttertoast.showToast(
        msg: "发送失败",
        gravity: ToastGravity.CENTER
      );
    }
  }

  /// 获取评论数据
  _getMomentComentsData({bool isLoadMore = false,String lastCommentId = ""}) async{
    String url = "http://api.cleven1.com/api/moments/commentsInfo?isLoadMore=${isLoadMore ? "1" : "0"}&offset_id=${lastCommentId}&moment_id=${widget.momentModel.momentId}";
    print(url);
    CLResultModel result = await CLDioUtil().requestGet(url);
    if(result.success){
        List<CLCommentsModel> tempArray = [];
        Map data = result.data["data"];
        List comments = data["comments"];
        for (var item in comments) {
          tempArray.add(CLCommentsModel.fromJson(item));
        }
      if (isLoadMore) {
        /// 把数据更新放到setState中会刷新页面
        setState(() {
          commentList.addAll(tempArray);
        });
      }else{
        if (tempArray.isEmpty && commentList.isEmpty) {
            CLCommentsModel model = CLCommentsModel(
              aliasName: widget.momentModel.aliasName,
              content: widget.momentModel.content,
              timeStamp: widget.momentModel.timeStamp,
              userInfo: CLUserinfo.fromJson(widget.momentModel.userInfo.toJson()),
              isEmptyContent: true
            );
            tempArray.add(model);
          }
        setState(() {
          commentList = tempArray;
        });
      }
    }else{
      Fluttertoast.showToast(
        msg: "获取失败",
        gravity: ToastGravity.CENTER
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getMomentComentsData();
  }

  @override
  void dispose() {
    FocusScope.of(context).requestFocus(FocusNode());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CLAppBar(title: "详情",),
      body: _getListViewContainer(),
    );
  }

  _getHeaderContainer(){
    return _getBaseContainer(
      widget.momentModel, 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CLText(text: widget.momentModel.content, maxLines: widget.momentModel.isDidFullButton ? 10000 : 6, style: TextStyle(color: Colors.pink),),
          SizedBox(height: 10,),
          widget.momentModel.isShowFullButton ? GestureDetector(
          onTap: (){
            setState(() {
              widget.momentModel.isDidFullButton = !widget.momentModel.isDidFullButton;
            });
          },
          child: CLText(text: widget.momentModel.isDidFullButton ? "收起" : "全文",style: TextStyle(color: Colors.blue),),) : Container(),
          SizedBox(height: 10,),
          widget.momentModel.momentType == 1 ? CLFlow(
            count: widget.momentModel.momentPics.length,
            children: _getImageContaniner(widget.momentModel),
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


  _getImageContaniner(CLMomentsModel model) {
    List<GestureDetector> images = [];
    List<String> pics = [];
    for (var i = 0; i < model.momentPics.length; i++) {
      String imageUrl = model.momentPics[i];
      pics.add(imageUrl);
      images.add(GestureDetector(
        onTap: (){
          // print("imageUrl == $imageUrl index == $i");
          CLPushUtil().pushNavigatiton(context, CLPhotoViewBrowser(pics: pics, currentIndex: i,));
        },
        child: ExtendedImage.network(imageUrl,cache: true,fit: BoxFit.cover,),
      ));
    }
    return images;
  }

  _getListViewContainer(){
    CLCommentsModel commentsModel = commentList.isEmpty ? CLCommentsModel() : commentList.first;
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
            listData: commentList,
            child: ListView.builder(
                itemCount: commentsModel.isEmptyContent == true ? 1 : commentList.length + 1,
                itemBuilder: (context,index) {
                  if (index == 0) {
                  return _getHeaderContainer();
                  }
                  CLCommentsModel commentsModel = commentList[index - 1];
                  return _getListViewItemContainer(commentsModel);
                },
              ),
            onRefresh: (){
              _getMomentComentsData();
            },
            loadMore: (){
              CLCommentsModel commentsModel = commentList.last;
              _getMomentComentsData(isLoadMore: true,lastCommentId: commentsModel.momentId);
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

  _getListViewItemContainer(CLCommentsModel commentsModel){
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(_focusNode);
        setState(() {
          replyId = commentsModel.momentId;
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
              text: commentsModel.replyUserInfo == null ? "" : "@${commentsModel.aliasName}:",
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
      name: commentsModel.replyUserName
       ),
    );

  }

   _getBaseContainer(var model, Widget child ,{Widget subChild, Color nameColor, String name}) {
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
              CLText(text: name == null ? model.aliasName : name,style: setTextStyle(textColor: nameColor == null ? Colors.black87 : nameColor),),
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

