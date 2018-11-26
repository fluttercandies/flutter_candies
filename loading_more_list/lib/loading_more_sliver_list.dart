import 'package:flutter/material.dart';
import 'package:loading_more_list/list_config.dart';
import 'package:loading_more_list/loading_more_base.dart';

class LoadingMoreSliverList<T> extends StatelessWidget {
  final SliverListConfig<T> sliverListConfig;

  LoadingMoreSliverList(this.sliverListConfig, {Key key}) : super(key: key) {}
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadingMoreBase>(
      builder: (d, s) {
        return sliverListConfig.buildContent(context, s.data);
      },
      stream: sliverListConfig.sourceList?.rebuild,
    );
  }
}

class LoadingMoreCustomScrollView extends StatefulWidget {
  final List<Widget> slivers;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final double cacheExtent;
  final int semanticChildCount;

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

  LoadingMoreCustomScrollView({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.cacheExtent,
    this.slivers = const <Widget>[],
    this.semanticChildCount,
    this.showGlowLeading: true,
    this.showGlowTrailing: true,
  }) : assert(slivers != null);
  @override
  _LoadingMoreCustomScrollViewState createState() =>
      _LoadingMoreCustomScrollViewState();
}

class _LoadingMoreCustomScrollViewState
    extends State<LoadingMoreCustomScrollView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>();
    bool showFullScreenLoading = true;
    var loadingMoreWidgets =
        List.castFrom<Widget, LoadingMoreSliverList>(widget.slivers);

    if (loadingMoreWidgets.length > 1) {
      if (widget.reverse) {
        for (int i = widget.slivers.length - 1; i >= 0; i--) {
          var item = widget.slivers[i];
          widgets.add(item);
          if (item is LoadingMoreSliverList) {
            item.sliverListConfig.showFullScreenLoading = showFullScreenLoading;
            showFullScreenLoading = false;
            item.sliverListConfig.showNoMore = loadingMoreWidgets.first == item;
            if (item.sliverListConfig.sourceList.hasMore) {
              break;
            }
          }
        }
      } else {
        for (int i = 0; i < widget.slivers.length; i++) {
          var item = widget.slivers[i];
          widgets.add(item);
          if (item is LoadingMoreSliverList) {
            item.sliverListConfig.showFullScreenLoading = showFullScreenLoading;
            showFullScreenLoading = false;
            item.sliverListConfig.showNoMore = loadingMoreWidgets.last == item;
            if (item.sliverListConfig.sourceList.hasMore) {
              break;
            }
          }
        }
      }
    } else {
      widgets = widget.slivers;
      if (widget.reverse) {
        widgets = widgets.reversed;
      }
    }

    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: _handleGlowNotification,
            child: CustomScrollView(
              semanticChildCount: widget.semanticChildCount,
              shrinkWrap: widget.shrinkWrap,
              scrollDirection: widget.scrollDirection,
              physics: widget.physics,
              primary: widget.primary,
              cacheExtent: widget.cacheExtent,
              controller: widget.controller,
              slivers: widgets,
            )));
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    //if (notification.depth != 0) return false;

    //reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      for (int i = 0; i < widget.slivers.length; i++) {
        var item = widget.slivers[i];
        if (item is LoadingMoreSliverList &&
            item.sliverListConfig.sourceList.hasMore &&
            !item.sliverListConfig.sourceList.isLoading) {
          setState(() {
            item.sliverListConfig.sourceList.loadMore();
          });
          break;
        }
      }
    }
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if ((notification.leading && !widget.showGlowLeading) ||
        (!notification.leading && !widget.showGlowTrailing)) {
      notification.disallowGlow();
    }
  }
}
