import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:example/common/common.dart';

///new ExtendedNestedScrollView
class ExtendedNestedScrollViewDemo extends StatefulWidget {
  @override
  _ExtendedNestedScrollViewDemoState createState() =>
      _ExtendedNestedScrollViewDemoState();
}

class _ExtendedNestedScrollViewDemoState
    extends State<ExtendedNestedScrollViewDemo> with TickerProviderStateMixin {
  TabController primaryTC;
  TabController secondaryTC;
  TabController secondaryTC1;
  @override
  void initState() {
    primaryTC = new TabController(length: 3, vsync: this);
    primaryTC.addListener(tabControlerListener);
    secondaryTC = new TabController(length: 4, vsync: this);
    secondaryTC1 = new TabController(length: 4, vsync: this);
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
        Tab(text: "Tab2"),
      ],
    );
    //var tabBarHeight = primaryTabBar.preferredSize.height;
    var pinnedHeaderHeight =
        //statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight;
    return NestedScrollViewRefreshIndicator(
      onRefresh: onRefresh,
      child: ExtendedNestedScrollView(
          headerSliverBuilder: (c, f) {
            return buildSliverHeader(false);
          },
          pinnedHeaderSliverHeight: pinnedHeaderHeight,
          keepOnlyOneInnerNestedScrollPositionActive: true,
          body: Column(
            children: <Widget>[
              //test special case
              Container(
                height: 100.0,
                child: PageView(
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      color: Colors.red,
                    ),
                    Container(
                      height: 100.0,
                      color: Colors.blue,
                    ),
                    Container(
                      height: 100.0,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

              primaryTabBar,
              Expanded(
                child: TabBarView(
                  controller: primaryTC,
                  children: <Widget>[
                    SecondaryTabView("Tab0", secondaryTC, false),
                    SecondaryTabView("Tab1", secondaryTC1, false),
//                    NestedScrollViewInnerScrollPositionKeyWidget(
//                        Key("Tab2"),
                    ListView.builder(
                      //store Page state
                      key: PageStorageKey("Tab2"),
                      itemBuilder: (c, i) {
                        return Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          child: Text(Key("Tab2").toString() + ": ListView$i"),
                        );
                      },
                      itemCount: 50,
                    )
                    //)
                  ],
                ),
              )
            ],
          )),
    );
  }
}
