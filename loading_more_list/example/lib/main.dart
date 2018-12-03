
import 'package:example/demo/custom_indicator_demo.dart';
import 'package:example/demo/grid_view_demo.dart';
import 'package:example/demo/list_view_demo.dart';
import 'package:example/demo/multiple_sliver_demo.dart';
import 'package:example/demo/sliver_grid_demo.dart';
import 'package:example/demo/sliver_list_demo.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'loading more demo',
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

class _MyHomePageState extends State<MyHomePage> {
  List<Page> pages = new List<Page>();
  @override
  void initState() {
    // TODO: implement initState
    pages.add(Page(PageType.ListView,
        "Show how to build loading more listview quickly"));
    pages.add(Page(PageType.GridView,
        "Show how to build loading more gridview quickly"));
    pages.add(Page(PageType.SliverList,
        "Show how to build loading more sliverlist quickly"));
    pages.add(Page(PageType.SliverGrid,
        "Show how to build loading more slivergrid quickly"));
    pages.add(Page(PageType.MultipleSliver,
        "Show how to build loading more multiple sliver list quickly"));
    pages.add(Page(PageType.CustomIndicator,
        "Show how to build loading more list with custom indicator quickly"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ListView.builder(
      itemBuilder: (_, int index) {
        var page = pages[index];
        var pageWidget = null;
        return Container(
          margin: EdgeInsets.all(20.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  (index + 1).toString() +
                      "." +
                      page.type.toString().replaceAll("PageType.", ""),
                  style: TextStyle(inherit: false),
                ),
                Text(
                  page.description,
                  style: TextStyle(inherit: false, color: Colors.grey),
                )
              ],
            ),
            onTap: () {
              switch (page.type) {
                case PageType.ListView:
                  pageWidget = new ListViewDemo();
                  break;
                case PageType.GridView:
                  pageWidget = new GridViewDemo();
                  break;
                case PageType.SliverList:
                  pageWidget = new SliverListDemo();
                  break;
                case PageType.SliverGrid:
                  pageWidget = new SliverGridDemo();
                  break;
                case PageType.MultipleSliver:
                  pageWidget = new MultipleSliverDemo();
                  break;
                case PageType.CustomIndicator:
                  pageWidget = new CustomIndicatorDemo();
                  break;
              }
              Navigator.push(context,
                  new MaterialPageRoute(builder: (BuildContext context) {
                return pageWidget;
              }));
            },
          ),
        );
      },
      itemCount: pages.length,
    );
  }
}

class Page {
  final PageType type;
  final String description;
  Page(this.type, this.description);
}

enum PageType {
  ListView,
  GridView,
  SliverList,
  SliverGrid,
  MultipleSliver,
  CustomIndicator,
}
