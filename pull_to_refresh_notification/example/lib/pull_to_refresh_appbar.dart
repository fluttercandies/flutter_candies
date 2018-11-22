import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class PullToRefreshAppbar extends StatefulWidget {
  @override
  _PullToRefreshAppbarState createState() => _PullToRefreshAppbarState();
}

class _PullToRefreshAppbarState extends State<PullToRefreshAppbar> {
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
          PullToRefreshContainer(buildPulltoRefreshAppbar),
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

  Widget buildPulltoRefreshAppbar(PullToRefreshScrollNotificationInfo info) {
    print(info?.mode);
    print(info?.dragOffset);
//    print("------------");
    var action = Padding(
      child: info?.refreshWiget ?? Icon(Icons.more_horiz),
      padding: EdgeInsets.all(15.0),
    );
    var offset = info?.dragOffset ?? 0.0;
//    var mode = info?.mode;
//    if (mode != null && mode == RefreshIndicatorMode.done) {
//      //showToast("Refresh done");
//    }
    return SliverAppBar(
        pinned: true,
        title: Text("PullToRefreshAppbar"),
        centerTitle: true,
        expandedHeight: 200.0 + offset,
        actions: <Widget>[action],
        flexibleSpace: FlexibleSpaceBar(
            //centerTitle: true,
            title: Text(
              info?.mode?.toString() ?? "",
              style: TextStyle(fontSize: 10.0),
            ),
            collapseMode: CollapseMode.pin,
            background: Image.asset(
              "assets/467141054.jpg",
              //fit: offset > 0.0 ? BoxFit.cover : BoxFit.fill,
              fit: BoxFit.cover,
            )));
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
