import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/empty_widget.dart';

class IndicatorWidget extends StatefulWidget {
  IndicatorStatus status;
  final Function tryAgain;
  final Widget text;
  final Color backgroundColor;
  final bool isSliver;
  IndicatorWidget(
    this.status, {
    this.tryAgain,
    this.text,
    this.backgroundColor,
    this.isSliver: false,
  });
  @override
  _IndicatorWidgetState createState() => _IndicatorWidgetState();
}

class _IndicatorWidgetState extends State<IndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    Widget widget;
    bool full = (this.widget.status == IndicatorStatus.FullScreenBusying ||
        this.widget.status == IndicatorStatus.FullScreenError);
    double height = 35.0;
    switch (this.widget.status) {
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
            this.widget.text ??
                (!full
                    ? Text(
                        "loading...",
                      )
                    : Text("loading...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28.0))),
          ],
        );
        break;
      case IndicatorStatus.Error:
      case IndicatorStatus.FullScreenError:
        widget = this.widget.text ??
            Text(
              "load failed,try again.",
            );
        break;
      case IndicatorStatus.NoMoreLoad:
        widget = this.widget.text ?? Text("No more items.");
        break;
      case IndicatorStatus.Empty:
        widget = EmptyWidget(
          this.widget.text ?? "nothing here",
        );
        break;
    }

    widget = Container(
        width: double.infinity,
        height: full ? double.infinity : height,
        child: widget,
        color: this.widget.backgroundColor ?? Colors.grey[200],
        alignment: Alignment.center);

    if (this.widget.tryAgain != null &&
        (this.widget.status == IndicatorStatus.Error ||
            this.widget.status == IndicatorStatus.FullScreenError)) {
      widget = GestureDetector(
        onTap: () {
          //setState(() {
          this.widget.tryAgain();
          // });
        },
        child: widget,
      );
    }

    if (this.widget.isSliver) {
      if (this.widget.status == IndicatorStatus.FullScreenBusying ||
          this.widget.status == IndicatorStatus.FullScreenError) {
        widget = SliverFillRemaining(
          child: widget,
        );
      } else if (this.widget.status == IndicatorStatus.Empty) {
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
  FullScreenError,
  NoMoreLoad,
  Empty
}
