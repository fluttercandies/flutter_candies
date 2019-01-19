import 'dart:async';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';

class SecondaryTabView extends StatefulWidget {
  final String tabKey;
  final TabController tc;
  final bool oldDemo;
  SecondaryTabView(this.tabKey,this.tc, this.oldDemo);
  @override
  _SecondaryTabViewState createState() => _SecondaryTabViewState();
}

class _SecondaryTabViewState extends State<SecondaryTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var secondaryTabBar = new TabBar(
      controller: widget.tc,
      labelColor: Colors.blue,
      indicatorColor: Colors.blue,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.0,
      isScrollable: false,
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(text: widget.tabKey+"0"),
        Tab(text: widget.tabKey+"1"),
        Tab(text: widget.tabKey+"2"),
        Tab(text: widget.tabKey+"3"),
      ],
    );
    return Column(
      children: <Widget>[
        secondaryTabBar,
        Expanded(
          child: TabBarView(
            controller: widget.tc,
            children: <Widget>[
              TabViewItem(Key(widget.tabKey+"0"), widget.oldDemo),
              TabViewItem(Key(widget.tabKey+"1"), widget.oldDemo),
              TabViewItem(Key(widget.tabKey+"2"), widget.oldDemo),
              TabViewItem(Key(widget.tabKey+"3"), widget.oldDemo),
            ],
          ),
        )
      ],
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

class TabViewItem extends StatefulWidget {
  final Key tabKey;
  final bool oldDemo;
  TabViewItem(this.tabKey, this.oldDemo);
  @override
  _TabViewItemState createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var child = Container(
      //margin: EdgeInsets.only(left: 190.0),
      child: ListView.builder(
          itemBuilder: (c, i) {
            return Container(
              //decoration: BoxDecoration(border: Border.all(color: Colors.orange,width: 1.0)),
              alignment: Alignment.center,
              height: 60.0,
              width: double.infinity,
              //color: Colors.blue,
              child: Text(widget.tabKey.toString() + ": List$i"),
            );
          },
          itemCount: 100,
          padding: EdgeInsets.all(0.0)),
    );

    if (widget.oldDemo) {
      return NestedScrollViewInnerScrollPositionKeyWidget(widget.tabKey, child);
    }

    /// new one doesn't need NestedScrollViewInnerScrollPositionKeyWidget any more.
    else {
      return child;
    }
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

class CommonSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  CommonSliverPersistentHeaderDelegate(this.child, this.height);

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(CommonSliverPersistentHeaderDelegate oldDelegate) {
    //print("shouldRebuild---------------");
    return oldDelegate != this;
  }
}

Future<Null> onRefresh() {
  final Completer<Null> completer = new Completer<Null>();
  new Timer(const Duration(seconds: 1), () {
    completer.complete(null);
  });
  return completer.future.then((_) {});
}

List<Widget> buildSliverHeader(bool old) {
  var widgets = <Widget>[];

  widgets.add(SliverAppBar(
      pinned: true,
      expandedHeight: 200.0,
      title: Text(old ? "old demo" : "new demo"),
      flexibleSpace: FlexibleSpaceBar(
          //centerTitle: true,
          collapseMode: CollapseMode.pin,
          background: Image.asset(
            "assets/467141054.jpg",
            fit: BoxFit.fill,
          ))));

  widgets.add(SliverGrid(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 0.0,
      mainAxisSpacing: 0.0,
    ),
    delegate: new SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Container(
          alignment: Alignment.center,
          height: 60.0,
          child: Text("Gird$index"),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 1.0)),
        );
      },
      childCount: 11,
    ),
  ));

  widgets.add(SliverList(
      delegate: SliverChildBuilderDelegate((c, i) {
    return Container(
      alignment: Alignment.center,
      height: 60.0,
      child: Text("SliverList$i"),
    );
  }, childCount: 4)));

//  widgets.add(SliverPersistentHeader(
//      pinned: true,
//      floating: false,
//      delegate: CommonSliverPersistentHeaderDelegate(
//          Container(
//            child: primaryTabBar,
//            //color: Colors.white,
//          ),
//          primaryTabBar.preferredSize.height)));
  return widgets;
}
