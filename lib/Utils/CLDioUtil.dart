import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

class CLDioUtil {
  static String baseUrl = '';
  static Map<String,String> baseHeaders = {
    // "platform":"iOS",
    // "application/json":"text/json"
  };

  /// 单例实现
  factory CLDioUtil() => _getInstance();
  static CLDioUtil get instance => _getInstance();
  static CLDioUtil _instance;
  CLDioUtil._internal(){
    /// 初始化
  }
  static CLDioUtil _getInstance() {
    if (_instance == null) {
      _instance = new CLDioUtil._internal();
    }
    return _instance;
  }
  
  int timeOut = 30 * 1000;
  setTimeOut(int timeOut){
    this.timeOut = timeOut * 1000;
  }

  requestPost(String url,{Map params}) async {
    return await _requestBase(url, params, baseHeaders, Options(method: 'post'));
  }

  requestGet(String url,{Map params}) async {
    return await _requestBase(url, params, baseHeaders, Options(method: 'get'));
  }

  _requestBase(String url, Map params, Map<String, String>header, Options option, {noTip = false}) async {

    /// 处理请求头
    Map<String,String> headers = Map();
    if (header !=null){
      headers.addAll(header);
    }
    /// options 处理
    if (option !=null) {
      option.headers = headers;
    }else{
      option = new Options(method: 'get');
      option.headers = headers;
    }
    /// 设置连接超时
    option.connectTimeout = this.timeOut;
    var dio = new Dio();
    Response response;
    Response errorResponse;
    try {
      if (!url.startsWith('http')) {
        url = baseUrl + url;
      }
      response = await dio.request(url,data: params,options: option);
    } on DioError catch (error) {
      if (error.response != null){
        errorResponse = error.response;
      }else{
        errorResponse = new Response(statusCode: 500);
      }
      if (error.type ==DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = -2; 
      }
      return new CLResultModel(errorResponse.data, false, errorResponse.statusCode);
    }
    try {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return new CLResultModel(response.data, true, response.statusCode);
        }else{
          return new CLResultModel(errorResponse.data, false, errorResponse.statusCode);
        }
      } catch (error) {
        return new CLResultModel(errorResponse.data, false, errorResponse.statusCode);
      }

  }

}
class CLResultModel {
  Map<String,dynamic> data;
  bool success;
  int code;
  var headers;

  CLResultModel(this.data, this.success, this.code, {this.headers});
}

