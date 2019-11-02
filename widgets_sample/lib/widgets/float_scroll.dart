import 'package:flutter/material.dart';

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
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController primaryTC;
  bool showTextField = false;

  @override
  void initState() {
    primaryTC = new TabController(length: 2, vsync: this);
    primaryTC.addListener(tabControlerListener);

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
    //final double statusBarHeight = MediaQuery.of(context).padding.top;
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
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: top,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Column(
              children: <Widget>[
                getTextField(color: Colors.red),
                primaryTabBar,
                Expanded(
                  child: TabBarView(
                    controller: primaryTC,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: 60.0,
                            color: Colors.red,
                            child: Text("我是固定的广告"),
                          ),
                          Expanded(
                            child: ListView.builder(
                              //store Page state
                              key: PageStorageKey("Tab1"),
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (c, i) {
                                return Container(
                                  alignment: Alignment.center,
                                  height: 60.0,
                                  child: Text(
                                      Key("Tab1").toString() + ": ListView$i"),
                                );
                              },
                              itemCount: 50,
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        //store Page state
                        key: PageStorageKey("Tab2"),
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (c, i) {
                          return Container(
                            alignment: Alignment.center,
                            height: 60.0,
                            child:
                                Text(Key("Tab1").toString() + ": ListView$i"),
                          );
                        },
                        itemCount: 50,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  double top = 0.0;
  bool onNotification(ScrollNotification notification) {
    if (notification.depth == 1) {
      if (notification is ScrollUpdateNotification) {
        var temp = (top - notification.scrollDelta).clamp(-50.0, 0.0);
        if (temp != top) {
          setState(() {
            top = temp;
          });
        }
      } else if (notification is OverscrollNotification) {
        print(notification.overscroll);
        var temp = (top - notification.overscroll).clamp(-50.0, 0.0);
        if (temp != top) {
          setState(() {
            top = temp;
          });
        }
      }
    }
  }
}

Widget getTextField({Color color}) {
  return Container(
    alignment: Alignment.center,
    child: Text("我是输入框"),
    height: 50.0,
    color: color ?? Colors.yellow,
  );
}