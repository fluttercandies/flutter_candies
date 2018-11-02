import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class PullToRefreshHeader extends StatefulWidget {
  @override
  _PullToRefreshHeaderState createState() => _PullToRefreshHeaderState();
}

class _PullToRefreshHeaderState extends State<PullToRefreshHeader> {

  int listlength=50;
  @override
  Widget build(BuildContext context) {
    return PullToRefreshNotification(
      color: Colors.blue,
      onRefresh: onRefresh,
      maxDragOffset: 80.0,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: Text("PullToRefreshHeader"),
          ),
          PullToRefreshContainer(buildPulltoRefreshHeader),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "List item : ${listlength-index}",
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

  Widget buildPulltoRefreshHeader(PullToRefreshScrollNotificationInfo info) {
//    print(info?.mode);
    print(info?.dragOffset);
//    print("------------");
    var offset = info?.dragOffset ?? 0.0;

    Widget refreshWiget = Container();
    //it should more than 18, so that RefreshProgressIndicator can be shown fully
    if (info?.refreshWiget != null && offset > 18.0) {
      refreshWiget = info.refreshWiget;
    }

    var mode = info?.mode;
//    if (mode != null && mode == RefreshIndicatorMode.refresh) {
//      //showToast("Refresh done");
//    }
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.grey,
        alignment: Alignment.bottomCenter,
        height: offset,
        width: double.infinity,
        //padding: EdgeInsets.only(top: offset),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            refreshWiget,
            Container(
              padding: EdgeInsets.only(left: 5.0),
              alignment: Alignment.center,
              child: Text(
                mode?.toString() ?? "",
                style: TextStyle(fontSize: 12.0, inherit: false),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> onRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(seconds: 2), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      setState(() {
        listlength+=10;
      });
    });
  }
}
