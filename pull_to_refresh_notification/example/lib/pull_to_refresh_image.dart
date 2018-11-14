import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class PullToRefreshImage extends StatefulWidget {
  @override
  _PullToRefreshImageState createState() => _PullToRefreshImageState();
}

class _PullToRefreshImageState extends State<PullToRefreshImage> {
  int listlength = 50;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PullToRefreshNotification(
      color: Colors.blue,
      pullBackOnRefresh: true,
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("PullToRefreshImage"),
          ),
          PullToRefreshContainer(buildPulltoRefreshImage),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "List item : ${listlength - index}",
                      style: TextStyle(fontSize: 15.0, inherit: false),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 2.0,
                    )
                  ],
                ));
          }, childCount: listlength)),
        ],
      ),
    );
  }

  Widget buildPulltoRefreshImage(PullToRefreshScrollNotificationInfo info) {
    print(info?.mode);
    print(info?.dragOffset);
//    print("------------");
    var offset = info?.dragOffset ?? 0.0;
    Widget refreshWiget = Container();
    if (info?.refreshWiget != null) {
      refreshWiget = Material(
        type: MaterialType.circle,
        color: Theme.of(context).canvasColor,
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: info.refreshWiget,
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              height: 200.0 + offset,
              width: double.infinity,
              child: Image.asset(
                "assets/467141054.jpg",
                //fit: offset > 0.0 ? BoxFit.cover : BoxFit.fill,
                fit: BoxFit.cover,
              )),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                refreshWiget,
                Container(
                  padding: EdgeInsets.only(left: 5.0),
                  alignment: Alignment.center,
                  child: Text(
                    info?.mode?.toString() ?? "",
                    style: TextStyle(fontSize: 12.0, inherit: false),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> onRefresh() {
    final Completer<bool> completer = new Completer<bool>();
    new Timer(const Duration(seconds: 2), () {
      completer.complete(true);
    });
    return completer.future.then((bool success) {
      if (success) {
        setState(() {
          listlength += 10;
        });
      }
      return success;
    });
  }
}
