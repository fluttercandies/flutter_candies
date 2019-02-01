
import 'package:example/pull_to_refresh_appbar.dart';
import 'package:example/pull_to_refresh_header.dart';
import 'package:example/pull_to_refresh_image.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pull to refresh Demo',
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
    pages.add(Page(PageType.PullToRefreshAppbar,
        "Show how to use pull to refresh notification to build a pull refresh appbar"));
    pages.add(Page(PageType.PullToRefreshHeader,
        "Show how to use pull to refresh notification to build a pull refresh header,and hide it on refresh done"));
    pages.add(Page(PageType.PullToRefreshImage,
        "Show how to use pull to refresh notification to build a pull refresh image"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ListView.builder(
      itemBuilder: (_, int index) {
        var page = pages[index];
        var pageWidget;
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
                case PageType.PullToRefreshAppbar:
                  pageWidget = new PullToRefreshAppbar();
                  break;
                case PageType.PullToRefreshHeader:
                  pageWidget = new PullToRefreshHeader();
                  break;
                case PageType.PullToRefreshImage:
                  pageWidget = new PullToRefreshImage();
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
  PullToRefreshAppbar,
  PullToRefreshHeader,
  PullToRefreshImage,
}
