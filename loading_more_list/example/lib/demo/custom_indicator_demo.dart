import 'dart:io';

import 'package:example/common/item_builder.dart';
import 'package:example/common/tu_chong_repository.dart';
import 'package:example/common/tu_chong_source.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    bool isSliver=false;
    Widget widget;
    bool full = (status == IndicatorStatus.FullScreenBusying ||
        status == IndicatorStatus.FullScreenError);
    double height = 35.0;
    switch (status) {
      case IndicatorStatus.None:
        widget = Container(height: 0.0);
        break;
      case IndicatorStatus.LoadingMoreBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5.0),
              height: 15.0,
              width: 15.0,
              child: getIndicator(context),
            ),
            Text("正在加载...稍等一下")
          ],
        );
        widget = _setbackground(false, widget, 35.0);
        break;
      case IndicatorStatus.FullScreenBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right:10.0),
              height: 30.0,
              width: 30.0,
              child: getIndicator(context),
            ),
            Text("正在加载...稍等一下")
          ],
        );
        widget = _setbackground(true, widget, double.infinity);
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        }
//        else {
//          widget = SingleChildScrollView(
        //  child: widget,
        // );
        //}
        break;
      case IndicatorStatus.Error:
        widget = Text(
           "加载失败，点击重试",
        );
        widget = _setbackground(false, widget, 35.0);

          widget = GestureDetector(
            onTap: () {
              listSourceRepository.errorRefresh();
            },
            child: widget,
          );

        break;
      case IndicatorStatus.FullScreenError:
        widget = Text(
          "加载失败，点击重试",
        );
        widget = _setbackground(true, widget, double.infinity);
          widget = GestureDetector(
            onTap: () {
              listSourceRepository.errorRefresh();
            },
            child: widget,
          );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        }
//        else {
//          widget = SingleChildScrollView(
//            child: widget,
//          );
//        }
        break;
      case IndicatorStatus.NoMoreLoad:
        widget = Text("没有更多了，不要拖了。。。");
        widget = _setbackground(false, widget, 35.0);
        break;
      case IndicatorStatus.Empty:
        widget = EmptyWidget(
          "这里只有空",
        );
        widget = _setbackground(true, widget, double.infinity);
        if (isSliver) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        }
        //else {
//          widget = SingleChildScrollView(
//            child: widget,
//          );
//        }
        break;
    }
    return widget;
  }

  Widget _setbackground(bool full, Widget widget, double height) {
    widget = Container(
        width: double.infinity,
        height: height,
        child: widget,
        color: Colors.grey[200],
        alignment: Alignment.center);
    return widget;
  }

  Widget getIndicator(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
      animating: true,
      radius: 16.0,
    )
        : CircularProgressIndicator(
      strokeWidth: 2.0,
      valueColor: AlwaysStoppedAnimation(Theme
          .of(context)
          .primaryColor),
    );
  }
}