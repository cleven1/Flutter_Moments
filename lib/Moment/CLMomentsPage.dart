import 'package:flutter/material.dart';
import '../custom/CLText.dart';
import 'package:extended_image/extended_image.dart';
import '../custom/CLFlow.dart';
import '../custom/CLListViewRefresh.dart';
import '../Utils/CLDioUtil.dart';
import '../Model/CLMomentsModel.dart';
import 'package:common_utils/common_utils.dart';
import '../Utils/CLUtil.dart';
import '../Utils/CLPushUtil.dart';
import 'CLPublishMomentPage.dart';
import './CLOptionsPage.dart';
import './CLPhotoViewBrowser.dart';
import 'package:flutter/services.dart';
import '../custom/HUD.dart';

class CLMomentsPage extends StatefulWidget {
  final Widget child;

  CLMomentsPage({Key key, this.child}) : super(key: key);

  _CLMomentsPageState createState() => _CLMomentsPageState();
}

class _CLMomentsPageState extends State<CLMomentsPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;   

  List <CLMomentsModel> mList = [];

  /// 传值channel
  MethodChannel channel = MethodChannel("moment");

  void initState() { 
    super.initState();
    /// 监听发布完成,更新数据
    channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "updateMomentsData"){
        getMomentsData();
      }
    });
    getMomentsData();
  }

  getMomentsData({bool isLoadMore = false,String lastId}) async {

    CLResultModel result = await CLDioUtil().requestGet("http://api.cleven1.com/api/moments/momentsList?isLoadMore=${isLoadMore ? 1 : 0}&offset_id=$lastId");
    List jsons = result.data['data'];
    List<CLMomentsModel> tempModel = [];
    jsons.forEach((model){
        tempModel.add(CLMomentsModel.fromJson(model));
      });
    if (isLoadMore) {
      /// 把数据更新放到setState中会刷新页面
      setState(() {
        mList.addAll(tempModel);
      });
    }else{
      setState(() {
        mList = tempModel;
      });
    }
      
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            getListViewContainer(),
            Positioned(
              right: 15,
              bottom: 25,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async{
                    final String greeting = await channel.invokeMethod("gotoMomentPublish");
                    print(greeting);
                    // CLPushUtil().pushNavigatiton(context, 
                    //   CLPublishMomentPage(pubilshMomentsSuccess: (){
                    //     getMomentsData();
                    //   },)
                    // );
                  },
                ),
            )
          ],
        ),
      ),
    );
  }

  getListViewContainer() {
    
    return CLListViewRefresh(
      listData: mList,
      child: ListView.builder(
        itemCount: mList.length,
        itemBuilder: (BuildContext context, int index) {
          CLMomentsModel model = mList[index];
          return model.momentType == 0 ? getItemTextContainer(model, index) : getItemImageContainer(model, index);
        },
      ),
      onRefresh: (){
        getMomentsData();
      },
      loadMore: (){
        getMomentsData(isLoadMore: true,lastId: mList.last.momentId);
      },
    );
  }

  /// 文本布局
  getItemTextContainer(CLMomentsModel model ,int index){
    
    return getItemBaseContainer(
      model: model,
      index: index,
      subChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getTextContainer(model),
          model.isShowFullButton ? getFullContainer(model) : Container(),
       ],
     )
    );
  }

  /// 图片布局
  getItemImageContainer(CLMomentsModel model, int index){
    return getItemBaseContainer(
      model: model,
      index: index,
      subChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getTextContainer(model),
          model.isShowFullButton ? getFullContainer(model) : Container(),
          SizedBox(height: 10,),
          CLFlow(
            count: model.momentPics.length,
            children: getImageContaniner(model),
          ),
        ],
      ),
    );
  }

  getTextContainer(CLMomentsModel model) {
    GlobalKey _myKey = new GlobalKey();
    
    CLText text = CLText(
        key: _myKey,
          text: model.content,
          maxLines: model.isDidFullButton ? 100000 : 6,
          style: setTextStyle(textColor: Colors.pinkAccent),
        );
      // RenderObject renderObject = _myKey.currentContext.findRenderObject();
      // print("semanticBounds:${renderObject.semanticBounds.size} paintBounds:${renderObject.paintBounds.size} size:${_myKey.currentContext.size}");
    return text; 
  }

  getImageContaniner(CLMomentsModel model) {
    List<GestureDetector> images = [];
    List<String> pics = [];
    for (var i = 0; i < model.momentPics.length; i++) {
      String imageUrl = model.momentPics[i];
      pics.add(imageUrl);
      images.add(GestureDetector(
        onTap: (){
          // print("imageUrl == $imageUrl index == $i");
          print("pics == ${pics.length}");
          channel.invokeMethod("photoBrowser",{
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

  getFullContainer(CLMomentsModel model){
    return Container(
          padding: EdgeInsets.only(top: 10),
          child: GestureDetector(
            onTap: (){
              setState(() {
                model.isDidFullButton = !model.isDidFullButton;  
              });
            },
            child: CLText(text: model.isDidFullButton ? '收起' : '全文',style: setTextStyle(textColor: Colors.blue),),
          )
        );
  }

  getItemBaseContainer({CLMomentsModel model, Widget subChild, int index}){
    int timeStamp = model.timeStamp == null ? CLUtil.currentTimeMillis() : int.parse(model.timeStamp);    
    String formatTime = TimelineUtil.format(timeStamp,dayFormat: DayFormat.Simple);
    String avatarUrl = model.avatarUrl == null ? model.userInfo.avatarUrl : model.avatarUrl;
    return GestureDetector(
      onTap: () async{
          print("object == $index  content == ${model.content}");
          final String greeting = await channel.invokeMethod("gotoDetailPage",model.momentId);
          print(greeting);
          // CLPushUtil().pushNavigatiton(context, CLMomentsDetailPage(momentModel: model,));
      },
      child: Container(
        padding: EdgeInsets.only(left: 15,right: 15,top: 15),
        child: Row(
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
                  CLText(
                    text: "${model.aliasName}",
                    textAlign: TextAlign.start,
                    style: setTextStyle(textColor: Colors.black87),
                  ),
                  CLText(
                    text: formatTime,//TimelineUtil.format(int.parse(model.timeStamp),dayFormat: DayFormat.Simple),//.formatByDateTime(formatTime,locale: 'zh').toString(),
                    style: setTextStyle(textColor: Colors.grey,fontSize: 12),
                  ),
                  SizedBox(height: 5,),
                  subChild,
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                CLOptionPage.showView(
                  context,
                  clickItemCallback: (CLOptionType type){
                    if (type == CLOptionType.delete){
                      print("删除");
                      CLOptionPage.hiddenView();
                      HUD().showMessageHud(context,content: "等待实现");
                  }
                });
              },
              child: Icon(Icons.more_horiz,),
            )
          ],
        ),
      ),
    );
  }
}
