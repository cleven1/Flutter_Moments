import 'package:flutter/material.dart';

class CLMomentsModel {
  String content;
  CLUserInfo userInfo;
  int likeCount;
  List momentPics;
  String timeStamp;
  int momentType;
  String aliasName;
  String avatarUrl;
  String momentId;
  int commentCout;

  /// 是否显示全文按钮
  bool isShowFullButton;
  bool isDidFullButton = false;

  CLMomentsModel(
      {this.content,
      this.userInfo,
      this.likeCount,
      this.momentPics,
      this.timeStamp,
      this.momentType,
      this.aliasName,
      this.avatarUrl,
      this.momentId,
      this.commentCout});

  CLMomentsModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    isShowFullButton = content.length > 100;
    userInfo = json['user_info'] != null
        ? new CLUserInfo.fromJson(json['user_info'])
        : null;
    likeCount = json['like_count'];
    momentPics = json['moment_pics'];
    timeStamp = json['time_stamp'];
    momentType = json['moment_type'];
    aliasName = json['alias_name'];
    avatarUrl = json['avatar_url'];
    momentId = json['moment_id'];
    commentCout = json['comment_cout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo.toJson();
    }
    data['like_count'] = this.likeCount;
    data['moment_pics'] = this.momentPics;
    data['time_stamp'] = this.timeStamp;
    data['moment_type'] = this.momentType;
    data['alias_name'] = this.aliasName;
    data['avatar_url'] = this.avatarUrl;
    data['moment_id'] = this.momentId;
    data['comment_cout'] = this.commentCout;
    return data;
  }
}

class CLUserInfo {
  String city;
  String birthday;
  String aliasName;
  String name;
  String avatarUrl;
  int gender;
  String userId;
  String description;

  CLUserInfo(
      {this.city,
      this.birthday,
      this.aliasName,
      this.name,
      this.avatarUrl,
      this.gender,
      this.userId,
      this.description});

  CLUserInfo.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    birthday = json['birthday'];
    aliasName = json['aliasName'];
    name = json['name'];
    avatarUrl = json['avatarUrl'];
    gender = json['gender'];
    userId = json['userId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['birthday'] = this.birthday;
    data['aliasName'] = this.aliasName;
    data['name'] = this.name;
    data['avatarUrl'] = this.avatarUrl;
    data['gender'] = this.gender;
    data['userId'] = this.userId;
    data['description'] = this.description;
    return data;
  }
}