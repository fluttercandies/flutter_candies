import 'dart:io';

import 'package:example/common/item_builder.dart';
import 'package:example/common/tu_chong_repository.dart';
import 'package:example/common/tu_chong_source.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/empty_widget.dart';
import 'package:loading_more_list/indicator_widget.dart';
import 'package:loading_more_list/list_config.dart';
import 'package:loading_more_list/loading_more_list.dart';

class CustomIndicatorDemo extends StatefulWidget {
  @override
  _CustomIndicatorDemoState createState() => _CustomIndicatorDemoState();
}

class _CustomIndicatorDemoState extends State<CustomIndicatorDemo> {
  TuChongRepository listSourceRepository;
  @override
  void initState() {
    // TODO: implement initState
    listSourceRepository = new TuChongRepository();
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("CustomIndicatorDemo"),
          ),
          Expanded(
            child: LoadingMoreList(
              ListConfig<TuChongItem>(
                  ItemBuilder.itemBuilder, listSourceRepository,
                  indicatorBuilder: _buildIndicator,
                  padding: EdgeInsets.all(0.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  //you can use IndicatorWidget or build yourself widget
  //in this demo, we define all status.
  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    Widget widget;
    bool full = (status == IndicatorStatus.FullScreenBusying);
    double height = 35.0;
    switch (status) {
      case IndicatorStatus.None:
        widget = Container(height: 0.0);
        height = 0.0;
        break;
      case IndicatorStatus.LoadingMoreBusying:
      case IndicatorStatus.FullScreenBusying:
        double indicatorSize = full ? 30.0 : 15.0;
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15.0),
                height: indicatorSize,
                width: indicatorSize,
                child: getIndicator(context)),
            (!full
                ? Text(
                    "正在加载...慌什么慌",
                  )
                : Text("正在加载...慌什么慌",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 28.0))),
          ],
        );
        break;
      case IndicatorStatus.Error:
        widget = Text(
          "加载失败，搞个川川",
        );
        break;
      case IndicatorStatus.NoMoreLoad:
        widget = Text("没有了，不要拖了");
        break;
      case IndicatorStatus.Empty:
        widget = EmptyWidget(
          "这里只有空",
        );
        break;
    }

    widget = Container(
        width: double.infinity,
        height: full ? double.infinity : height,
        child: widget,
        color: Colors.grey[200],
        alignment: Alignment.center);

//    if (isSliver) {
//      if (status == IndicatorStatus.FullScreenBusying) {
//        widget = SliverFillRemaining(
//          child: widget,
//        );
//      } else if (status == IndicatorStatus.Empty) {
//        widget = SliverToBoxAdapter(
//          child: widget,
//        );
//      }
//    }
    if (status == IndicatorStatus.Error) {
      widget = GestureDetector(
        onTap: () {
          listSourceRepository.loadMore();
        },
        child: widget,
      );
    }
    return widget;
  }
}

Widget getIndicator(BuildContext context) {
  return Platform.isIOS
      ? CupertinoActivityIndicator(
    animating: true,
    radius: 16.0,
  )
      : CircularProgressIndicator(
    strokeWidth: 2.0,
    valueColor: AlwaysStoppedAnimation(Colors.red),
  );
}