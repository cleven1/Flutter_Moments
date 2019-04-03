import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';


/// 定义回调类型
typedef Future<void> OnRefresh();
typedef Future<void> LoadMore();

class CLListViewRefresh extends StatefulWidget {
  final List listData;
  final Widget child;
  final OnRefresh onRefresh;
  final LoadMore loadMore;

  CLListViewRefresh({
    Key key ,
    @required this.child, 
    @required this.listData, 
    this.onRefresh, 
    this.loadMore}) : super(key: key);

  _CLListViewRefreshState createState() => _CLListViewRefreshState();
}

class _CLListViewRefreshState extends State<CLListViewRefresh> {
  @override
  Widget build(BuildContext context) {
    return getListViewContainer();
  }

  GlobalKey<EasyRefreshState> easyRefreshKey;
  GlobalKey<RefreshHeaderState> headerKey;
  GlobalKey<RefreshFooterState> footerKey;
  void initState() { 
    super.initState();
    easyRefreshKey = new GlobalKey<EasyRefreshState>();
    headerKey = new GlobalKey<RefreshHeaderState>();
    footerKey = new GlobalKey<RefreshFooterState>();
  }

  getListViewContainer() {

    if (widget.listData.isEmpty){ /// 没有数据时显示loading状态
      return Center(child: CupertinoActivityIndicator(),);
    }
    
    return EasyRefresh(
      key: easyRefreshKey,
      refreshHeader: getBallHeader(),
      refreshFooter: getBallFotter(),
        /// 下拉刷新
      onRefresh: widget.onRefresh, 
      loadMore: widget.loadMore,/// 上拉加载
      behavior: ScrollOverBehavior(),
      autoLoad: true,
      child: widget.child,
    );
  }

  getBallHeader(){
    return BallPulseHeader(
      key: headerKey,
    );
  }

  getBallFotter() {
    return BallPulseFooter(
      key: footerKey,
    );
  }

  getCustomHeader(){
    var now = DateTime.now();
    var formatter = '${now.hour.toString()}:${now.minute.toString()}:${now.second.toString()}';
    return ClassicsHeader(
          key: headerKey,
          refreshText: '下拉刷新',
          refreshReadyText: '松手刷新',
          refreshingText: '正在刷新',
          refreshedText: '刷新结束',
          moreInfo: '更新时间: ${formatter}',
          bgColor: Colors.transparent,
          textColor: Colors.black87,
          moreInfoColor: Colors.black54,
          showMore: true,
      );
  }

  getCustomFooter(){
    var now = DateTime.now();
    var formatter = '${now.hour.toString()}:${now.minute.toString()}:${now.second.toString()}';
    return ClassicsFooter(
        key: footerKey,
        loadText: '上拉刷新',
        loadReadyText: '松手刷新',
        loadingText: '正在加载...',
        loadedText: '加载完成',
        noMoreText: '加载完成',
        moreInfo: '更新时间: ${formatter}',
        bgColor: Colors.transparent,
        textColor: Colors.black87,
        moreInfoColor: Colors.black54,
        showMore: true,
      );
  }
}