import 'package:example/common/common.dart';
import 'package:example/extended_nested_scroll_view_demo.dart';
import 'package:example/old_extened_nested_scroll_view_demo.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:extended_nested_scroll_view/src/nested_scroll_view_refresh_indicator.dart';

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
  List<Page> pages = new List<Page>();
  @override
  void initState() {
    // TODO: implement initState
    pages.add(Page(PageType.Old,
        "extended nested scroll view to fix pinned header and inner scrollables sync issues."));
    pages.add(Page(PageType.New,
        "new one to solve inner scrollables sync issues more smartly"));
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
                case PageType.Old:
                  pageWidget = new OldExtendedNestedScrollViewDemo();
                  break;
                case PageType.New:
                  pageWidget = new ExtendedNestedScrollViewDemo();
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
  Old,
  New,
}
