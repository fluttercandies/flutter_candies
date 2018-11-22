import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/empty_widget.dart';

const Color textColor = Color(0xffdcdcdc);

class IndicatorWidget extends StatelessWidget {
  final IndicatorStatus status;
  final Function tryAgain;
  final Widget text;
  final Widget progressIndicator;
  final Color backgroundColor;
  final bool isSliver;
  final String emptyMsg;
  final Widget emptyWidget;
  IndicatorWidget(this.status,
      {this.tryAgain,
      this.text,
      this.progressIndicator,
      this.backgroundColor,
      this.isSliver: false,
      this.emptyMsg,
      this.emptyWidget});
  @override
  Widget build(BuildContext context) {
    if (progressIndicator != null) return progressIndicator;
    Widget widget;
    bool full = (status == IndicatorStatus.FullScreenBusying);
    double height = 35.0;
    switch (status) {
      case IndicatorStatus.None:
        widget = Container(height: 0.0);
        height=0.0;
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
            text ??
                (!full
                    ? Text(
                        "loading...",
                        style: TextStyle(
                          color: textColor,
                        ),
                      )
                    : Text("loading...",
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0))),
          ],
        );
        break;
      case IndicatorStatus.Error:
        widget = text ??
            Text("load error.",
                style: TextStyle(
                  color: textColor,
                ));
        if (tryAgain != null) {
          widget = GestureDetector(
            onTap: () {
              tryAgain();
            },
            child: widget,
          );
        }
        break;
      case IndicatorStatus.NoMoreLoad:
        widget = text ??
            Text("No more items.",
                style: TextStyle(
                  color: textColor,
                ));
        break;
      case IndicatorStatus.Empty:
        widget = EmptyWidget(
          emptyMsg??"Nothing here",
          emptyWidget: emptyWidget,
        );
        break;
    }

    widget = Container(
        width: double.infinity,
        height: full ? double.infinity : height,
        child: widget,
        color: backgroundColor ?? Colors.grey[200],
        alignment: Alignment.center);

    if (isSliver) {
      if (status == IndicatorStatus.FullScreenBusying) {
        widget = SliverFillRemaining(
          child: widget,
        );
      } else if (status == IndicatorStatus.Empty) {
        widget = SliverToBoxAdapter(
          child: widget,
        );
      }
    }

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
  NoMoreLoad,
  Empty
}
