import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color textColor = Color(0xffdcdcdc);

class LoadingIndicatorWidget extends StatelessWidget {
  final LoadingIndicatorStatus status;
  final Function tryAgain;
  final Widget text;
  final Widget progressIndicator;
  final Color backgroundColor;
  LoadingIndicatorWidget(this.status,
      {this.tryAgain, this.text, this.progressIndicator, this.backgroundColor});
  @override
  Widget build(BuildContext context) {
    if (progressIndicator != null) return progressIndicator;
    Widget widget;
    bool full = status == LoadingIndicatorStatus.FullScreenBusying ||
        status == LoadingIndicatorStatus.SliverFullScreenBusying;
    switch (status) {
      case LoadingIndicatorStatus.None:
        widget = Container();
        break;
      case LoadingIndicatorStatus.LoadingMoreBusying:
      case LoadingIndicatorStatus.FullScreenBusying:
      case LoadingIndicatorStatus.SliverFullScreenBusying:
        double indicatorSize = full ? 30.0 : 15.0;
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 0.0),
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
      case LoadingIndicatorStatus.Error:
        widget = text ??
            Text("there is some error.",
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
      case LoadingIndicatorStatus.NoMoreLoad:
        widget = text ??
            Text("No more items.",
                style: TextStyle(
                  color: textColor,
                ));
        break;
    }

    widget = Container(
        width: double.infinity,
        height: full ? double.infinity : 35.0,
        child: widget,
        color: backgroundColor ?? Colors.grey[200],
        alignment: Alignment.center);
    if (status == LoadingIndicatorStatus.SliverFullScreenBusying) {
      widget = SliverFillRemaining(
        child: widget,
      );
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

enum LoadingIndicatorStatus {
  None,
  LoadingMoreBusying,
  FullScreenBusying,
  //busy loading for sliver list
  SliverFullScreenBusying,
  Error,
  NoMoreLoad,
}
