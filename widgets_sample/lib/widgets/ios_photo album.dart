import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

void main() {
  runApp(MyApp());
}

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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

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

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey key = GlobalKey();

  int totalCount = 1000;
  int count = 22;
  int placeholderCount;
  int crossAxisCount = 3;
  double textHeight = 50;
  @override
  void initState() {
    super.initState();
    placeholderCount = totalCount % crossAxisCount == 0
        ? 0
        : crossAxisCount - totalCount % crossAxisCount;

    count = min(count, totalCount);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'IosPhotoAlbum',
          ),
        ),
        body: PullToRefreshNotification(
          onRefresh: onRefresh,
          maxDragOffset: 48,
          armedDragUpCancel: false,
          child: LayoutBuilder(
            builder: (BuildContext c, BoxConstraints d) {
              final double windowWidth = d.maxWidth;
              final double windowHeight = d.maxHeight;
              final double girdWidth = windowWidth / 3;
              // setting center initial
              final double anchor = min(
                  ((totalCount + placeholderCount) ~/ crossAxisCount) *
                      girdWidth /
                      windowHeight,
                  (windowHeight - textHeight) / windowHeight);

              return Directionality(
                textDirection: TextDirection.rtl,
                child: CustomScrollView(
                  /// in case list is not full screen and remove ios Bouncing
                  physics: const AlwaysScrollableClampingScrollPhysics(),
                  anchor: anchor,
                  center: key,
                  slivers: <Widget>[
                    PullToRefreshContainer(
                      (PullToRefreshScrollNotificationInfo info) {
                        final double offset = info?.dragOffset ?? 0.0;
                        return SliverToBoxAdapter(
                          child: Container(
                            height: offset,
                            alignment: Alignment.center,
                            child: const CupertinoActivityIndicator(
                                activeColor: Colors.blue),
                          ),
                        );
                      },
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index < placeholderCount) {
                            return Container();
                          }
                          index -= placeholderCount;
                          return buildItem(index);
                        },
                        childCount: count + placeholderCount,
                      ),
                    ),
                    SliverToBoxAdapter(
                      key: key,
                      child: Container(
                        height: textHeight,
                        color: Colors.blue,
                        alignment: Alignment.center,
                        child: Text(
                          'total: $totalCount picture.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildItem(int index) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: Center(
          child: Text('$index'),
        ),
      ),
    );
  }

  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(seconds: 1), () {
      setState(() {
        count += 21;
        count = min(count, totalCount);
      });
      return true;
    });
  }
}
