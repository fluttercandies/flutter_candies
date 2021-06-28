import 'dart:async';
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:widgets_sample/assets.dart';

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
  List<ChatItem> chats = <ChatItem>[];
  List<ChatItem> newChats = <ChatItem>[];
  GlobalKey key = GlobalKey();
  ScrollController _scrollController;
  int newMeassageCount;
  StreamController<int> streamController = StreamController<int>.broadcast();

  int maxLastIndex = 0;
  bool isJumping = false;
  String currentMsg;
  @override
  void initState() {
    for (int i = 0; i < 5; i++) {
      chats.add(ChatItem('today'));
    }
    _scrollController = ScrollController();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ChatListSample',
        ),
        actions: <Widget>[
          FlatButton(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                // insert new data
                final bool reachBottom =
                    _scrollController.position.extentAfter == 0 &&
                        _scrollController.position.maxScrollExtent != 0;

                chats.add(ChatItem('new'));
                currentMsg = chats.last.value;
                //if reach bottom, scroll to bottom.
                if (reachBottom) {
                  isJumping = true;
                  Future<void>.delayed(
                    const Duration(milliseconds: 500),
                    () {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                      isJumping = false;
                    },
                  );
                } else {
                  if (_scrollController.position.maxScrollExtent != 0) {
                    streamController.sink.add(++newMeassageCount);
                  }
                }
              });
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          PullToRefreshNotification(
            onRefresh: onRefresh,
            maxDragOffset: 48,
            armedDragUpCancel: false,
            child: Column(
              children: <Widget>[
                Expanded(
                    child: CustomScrollView(
                  /// in case list is not full screen and remove ios Bouncing
                  physics: const AlwaysScrollableClampingScrollPhysics(),
                  controller: _scrollController,
                  center: key,
                  slivers: <Widget>[
                    PullToRefreshContainer(
                      (PullToRefreshScrollNotificationInfo info) {
                        final double offset = info?.dragOffset ?? 0.0;
                        //loading history data
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
                    ExtendedSliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final ChatItem item = newChats[index];
                          return buildItem(item);
                        },
                        childCount: newChats.length,
                      ),
                      extendedListDelegate: const ExtendedListDelegate(
                        closeToTrailing: false,
                      ),
                    ),
                    ExtendedSliverList(
                      key: key,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final ChatItem item = chats[index];
                          return buildItem(item);
                        },
                        childCount: chats.length,
                      ),
                      extendedListDelegate: ExtendedListDelegate(
                          //closeToTrailing: true,
                          viewportBuilder: (int firstIndex, int lastIndex) {
                        maxLastIndex = max(maxLastIndex, lastIndex);
                        if (!isJumping &&
                            newMeassageCount !=
                                chats.length - 1 - maxLastIndex) {
                          newMeassageCount = chats.length - 1 - maxLastIndex;
                          streamController.sink.add(newMeassageCount);
                        }
                      }),
                    ),
                  ],
                ))
              ],
            ),
          ),
          StreamBuilder<int>(
            builder: (BuildContext context, AsyncSnapshot<int> data) {
              if (data.data == null || data.data <= 0 || currentMsg == null) {
                return Container();
              }
              return Positioned(
                child: Container(
                  height: 50,
                  color: Colors.grey.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: Text(currentMsg),
                ),
                top: 0,
                left: 0,
                right: 0,
              );
            },
            initialData: newMeassageCount,
            stream: streamController.stream,
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<int>(
        builder: (BuildContext context, AsyncSnapshot<int> data) {
          if (data.data == null || data.data <= 0) {
            return Container();
          }
          return FloatingActionButton(
            onPressed: null,
            child: Text('${data.data}'),
          );
        },
        initialData: newMeassageCount,
        stream: streamController.stream,
      ),
    );
  }

  Widget buildItem(ChatItem item) {
    List<Widget> children = <Widget>[
      Text('${item.flag} ${item.value}'),
      Image.asset(
        Assets.assets_avatar_jpg,
        width: 30,
        height: 30,
      ),
    ];
    if (item.left) {
      children = children.reversed.toList();
    }
    return Row(
      mainAxisAlignment:
          item.left ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: children,
    );
  }

  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(seconds: 1), () {
      setState(() {
        for (int i = 0; i < 10; i++) {
          newChats.add(ChatItem('history'));
        }
      });
      return true;
    });
  }
}

class ChatItem {
  ChatItem(this.flag) {
    left = Random().nextBool();
    value = generateWordPairs().take(1).first.asString;
  }
  bool left;
  String value;
  String flag;
}
