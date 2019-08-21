import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:like_this/api/Api.dart';
import 'package:like_this/util/HttpUtil.dart';
import 'package:like_this/widget/header/space_header.dart';
import 'package:like_this/gson/user_post_item_entity.dart';

void main() {
  runApp(new MaterialApp(
    home: new HomePostPurse(),
  ));
}

class HomePostPurse extends StatefulWidget {
  @override
  _HomePostPurseState createState() => new _HomePostPurseState();
}

class _HomePostPurseState extends State<HomePostPurse> {
  int _count = 20;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPurseDataList();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(top: 55),
      child: EasyRefresh(
        header: ClassicalHeader(
            enableInfiniteRefresh: false,
            refreshedText: "刷新成功了哦！",
            noMoreText: "没有数据了哦！",
            showInfo: false,
            infoText: "",
            refreshReadyText: "赶快放开我！",
            refreshingText: "刷新中..."),
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _count = 20;
            });
          });
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2), () {
            setState(() {
              _count += 20;
            });
          });
        },
        child: getBody(),
      ),
    );
  }

  int count = 1;
  List<UserPostItemData> userPostItem = List();

  getBody() {
    if (userPostItem.length != 0) {
      return ListView.builder(
          itemCount: userPostItem.length,
          itemBuilder: (BuildContext context, int position) {
            return setUserPostList(userPostItem[position]);
          });
    } else {
      // 加载菊花
      return CupertinoActivityIndicator();
    }
  }

  void getPurseDataList() async {
    var response = await HttpUtil.getInstance().get(Api.QUERY_POST_LIST,
        data: {"page": count, "userId": "1", "isUser": ""});
    var decode = json.decode(response.toString());
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);

    setState(() {
      userPostItem = userPostItemEntity.data;
      print(userPostItem.length);
    });
  }

  // ignore: missing_return
  setUserPostList(UserPostItemData index) {
    return Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: FadeInImage.assetNetwork(
                placeholder: "assert/imgs/loading.gif",
                image: "${index.user.avatar}",
                fit: BoxFit.cover,
                width: 44,
                height: 44,
              ),
            ),
            new Column(
              children: <Widget>[
                new Text("${index.user.nickname}"),
                new Text("${index.timeDuration}"),
              ],
            )
          ],
        )
      ],
    );
  }
}
