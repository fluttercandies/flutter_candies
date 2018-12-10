import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/src/empty_widget.dart';

class IndicatorWidget extends StatelessWidget {
  IndicatorStatus status;
  final Function tryAgain;
  final String text;
  final Color backgroundColor;
  final bool isSliver;
  Widget emptyWidget;
  IndicatorWidget(this.status,
      {this.tryAgain,
        this.text,
        this.backgroundColor,
        this.isSliver: false,
        this.emptyWidget});
  @override
  @override
  Widget build(BuildContext context) {
    Widget widget;
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
              child:getIndicator(context),
            ),
            Text(text??"loading...")
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
              margin: EdgeInsets.only(right: 0.0),
              height: 30.0,
              width: 30.0,
              child:getIndicator(context),
            ),
           Text(text??"loading...")
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
          text ?? "load failed,try again.",
        );
        widget = _setbackground(false, widget, 35.0);
        if (tryAgain != null) {
          widget = GestureDetector(
            onTap: () {
              tryAgain();
            },
            child: widget,
          );
        }
        break;
      case IndicatorStatus.FullScreenError:
        widget = Text(
          text ?? "load failed,try again.",
        );
        widget = _setbackground(true, widget, double.infinity);
        if (tryAgain != null) {
          widget = GestureDetector(
            onTap: () {
              tryAgain();
            },
            child: widget,
          );
        }
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
        widget = Text(text ?? "No more items.");
        widget = _setbackground(false, widget, 35.0);
        break;
      case IndicatorStatus.Empty:
        widget = EmptyWidget(
          text ?? "nothing here",
          emptyWidget: emptyWidget,
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
        color: backgroundColor ?? Colors.grey[200],
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
      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
    );
  }
}


enum IndicatorStatus {
  None,
  LoadingMoreBusying,
  FullScreenBusying,
  Error,
  FullScreenError,
  NoMoreLoad,
  Empty
}
