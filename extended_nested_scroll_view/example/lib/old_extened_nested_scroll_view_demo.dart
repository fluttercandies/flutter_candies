import 'package:example/common/common.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

///old demo
class OldExtendedNestedScrollViewDemo extends StatefulWidget {
  @override
  _OldExtendedNestedScrollViewDemoState createState() =>
      _OldExtendedNestedScrollViewDemoState();
}

class _OldExtendedNestedScrollViewDemoState
    extends State<OldExtendedNestedScrollViewDemo>
    with TickerProviderStateMixin {
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
  //click fire twice ,gesture fire onetime
  int index;
  void tabControlerListener() {
//    if (index != primaryTC.index)
//    //if(primaryTC.indexIsChanging)
//    //if(primaryTC.previousIndex!=primaryTC.index)
//    {
//      setState(() {});
//    }
//    index = primaryTC.index;
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
        //statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight;
    return NestedScrollViewRefreshIndicator(
      onRefresh: onRefresh,
      child: NestedScrollView(
          headerSliverBuilder: (c, f) {
            return buildSliverHeader(true);
          },
          //
          pinnedHeaderSliverHeightBuilder: () {
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
          body: Column(
            children: <Widget>[
              primaryTabBar,
              Expanded(
                child: TabBarView(
                  controller: primaryTC,
                  children: <Widget>[
                    SecondaryTabView(secondaryTC, true),
                    NestedScrollViewInnerScrollPositionKeyWidget(
                        Key("Tab1"),
                        ListView.builder(
                          //store Page state
                          key: PageStorageKey("Tab1"),
                          itemBuilder: (c, i) {
                            return Container(
                              alignment: Alignment.center,
                              height: 60.0,
                              child:
                                  Text(Key("Tab1").toString() + ": ListView$i"),
                            );
                          },
                          itemCount: 50,
                        ))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
