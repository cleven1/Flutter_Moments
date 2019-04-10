

class CLCommentsModel {
	CLUserinfo replyUserInfo;
	String momentId;
	String content;
	CLUserinfo userInfo;
	String replyUserName;
	String timeStamp;
	String aliasName;
  String avatarUrl;
  /// 判断是否有评论数据
  bool isEmptyContent = false;

	CLCommentsModel({this.replyUserInfo, this.momentId, this.content, this.userInfo, this.replyUserName, this.timeStamp, this.aliasName, this.avatarUrl, this.isEmptyContent});

	CLCommentsModel.fromJson(Map<String, dynamic> json) {
		replyUserInfo = json['reply_user_info'] != null ? new CLUserinfo.fromJson(json['reply_user_info']) : null;
		momentId = json['moment_id'];
		content = json['content'];
		userInfo = json['user_info'] != null ? new CLUserinfo.fromJson(json['user_info']) : null;
		replyUserName = json['reply_user_name'];
		timeStamp = json['time_stamp'];
		aliasName = json['alias_name'];
    avatarUrl = json['avatar_url'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.replyUserInfo != null) {
      data['reply_user_info'] = this.replyUserInfo.toJson();
    }
		data['moment_id'] = this.momentId;
		data['content'] = this.content;
		if (this.userInfo != null) {
      data['user_info'] = this.userInfo.toJson();
    }
		data['reply_user_name'] = this.replyUserName;
		data['time_stamp'] = this.timeStamp;
		data['alias_name'] = this.aliasName;
    data['avatar_url'] = this.avatarUrl;
		return data;
	}
}

class CLUserinfo {
  String city;
  String birthday;
  String aliasName;
  String name;
  String avatarUrl;
  int gender;
  String userId;
  String description;

  CLUserinfo(
      {this.city,
      this.birthday,
      this.aliasName,
      this.name,
      this.avatarUrl,
      this.gender,
      this.userId,
      this.description});

  CLUserinfo.fromJson(Map<String, dynamic> json) {
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