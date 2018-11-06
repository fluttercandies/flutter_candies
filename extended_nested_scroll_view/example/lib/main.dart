import 'dart:async';

import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:extended_nested_scroll_view/nested_scroll_view_refresh_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController primaryTC;
  TabController secondaryTC;
  @override
  void initState() {
    primaryTC = new TabController(length: 2, vsync: this);
    primaryTC.addListener(tabControlerListener);
    secondaryTC = new TabController(length: 4, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    primaryTC.removeListener(tabControlerListener);
    // TODO: implement dispose
    super.dispose();
  }

  //when primary tabcontroller tab,rebuild headerSliverBuilder
  void tabControlerListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var primaryTabBar = new TabBar(
      controller: primaryTC,
      labelColor: Colors.blue,
      indicatorColor: Colors.blue,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.0,
      isScrollable: false,
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(text: "Tab0"),
        Tab(text: "Tab1"),
      ],
    );
    var tabBarHeight = primaryTabBar.preferredSize.height;
    var pinnedHeaderHeight =
        //statusBa height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight +
            //pinned tabbar height in header
            (primaryTC.index == 0 ? tabBarHeight * 2 : tabBarHeight);
    return NestedScrollViewRefreshIndicator(
      onRefresh: onRefresh,
      child: extended.NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (c, f) {
          return _buildSliverHeader(primaryTabBar);
        },
        //
        pinnedHeaderHeightBuilder: () {
          return pinnedHeaderHeight;
        },
        innerScrollPositionKeyBuilder: () {
          var index = "Tab";
          if (primaryTC.index == 0) {
            index +=
                (primaryTC.index.toString() + secondaryTC.index.toString());
          } else {
            index += primaryTC.index.toString();
          }
          return Key(index);
        },
        body: TabBarView(
          controller: primaryTC,
          children: <Widget>[
            SecondaryTabView(secondaryTC),
            extended.NestedScrollViewInnerScrollPositionKeyWidget(
                Key("Tab1"),
                ListView.builder(
                  //store Page state
                  key: PageStorageKey("Tab1"),
                  itemBuilder: (c, i) {
                    return Container(
                      alignment: Alignment.center,
                      height: 60.0,
                      child: Text(Key("Tab1").toString() + ": ListView$i"),
                    );
                  },
                  itemCount: 50,
                ))
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSliverHeader(TabBar primaryTabBar) {
    var widgets = <Widget>[];

    widgets.add(SliverAppBar(
        pinned: true,
        expandedHeight: 200.0,
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

    widgets.add(SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: CommonSliverPersistentHeaderDelegate(
            Container(
              child: primaryTabBar,
              //color: Colors.white,
            ),
            primaryTabBar.preferredSize.height)));

    if (primaryTC.index == 0) {
      var secondaryTabBar = new TabBar(
        controller: secondaryTC,
        labelColor: Colors.blue,
        indicatorColor: Colors.blue,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2.0,
        isScrollable: false,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(text: "Tab00"),
          Tab(text: "Tab01"),
          Tab(text: "Tab02"),
          Tab(text: "Tab03"),
        ],
      );

      widgets.add(SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: CommonSliverPersistentHeaderDelegate(
              Container(
                child: secondaryTabBar,
                //color: Colors.white,
              ),
              secondaryTabBar.preferredSize.height)));
    }
    return widgets;
  }
}

class SecondaryTabView extends StatefulWidget {
  final TabController tc;
  SecondaryTabView(this.tc);
  @override
  _SecondaryTabViewState createState() => _SecondaryTabViewState();
}

class _SecondaryTabViewState extends State<SecondaryTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tc,
      children: <Widget>[
        TabViewItem(Key("Tab00")),
        TabViewItem(Key("Tab01")),
        TabViewItem(Key("Tab02")),
        TabViewItem(Key("Tab03")),
      ],
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}

class TabViewItem extends StatefulWidget {
  final Key tabKey;
  TabViewItem(this.tabKey);
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
    return extended.NestedScrollViewInnerScrollPositionKeyWidget(
        widget.tabKey,
        // myRefresh.RefreshIndicator(
        // child:
        ListView.builder(
            itemBuilder: (c, i) {
              return Container(
                //decoration: BoxDecoration(border: Border.all(color: Colors.orange,width: 1.0)),
                alignment: Alignment.center,
                height: 60.0,
                child: Text(widget.tabKey.toString() + ": List$i"),
              );
            },
            itemCount: 100)
        //,
        //onRefresh: onRefresh,
        // )
        );
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
