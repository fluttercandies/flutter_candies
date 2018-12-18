import 'package:flutter/material.dart';
import 'package:loading_more_list/src/glow_notification_widget.dart';
import 'package:loading_more_list/src/list_config.dart';
import 'package:loading_more_list/src/loading_more_base.dart';

//loading more for sliverlist and sliverGrid
class LoadingMoreSliverList<T> extends StatelessWidget {
  final SliverListConfig<T> sliverListConfig;

  LoadingMoreSliverList(this.sliverListConfig, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadingMoreBase>(
      builder: (b, s) {
        return sliverListConfig.buildContent(context, s.data);
      },
      stream: sliverListConfig.sourceList?.rebuild,
    );
  }
}

//support for LoadingMoreSliverList
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

  //in case : in loadingmore sliverlist in NestedScrollView,you should rebuild CustomScrollView,
  //so that viewport can be computed again.
  final bool rebuildCustomScrollView;

  List<LoadingMoreSliverList> _loadingMoreWidgets;

  LoadingMoreCustomScrollView(
      {Key key,
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
      this.rebuildCustomScrollView: false})
      : assert(slivers != null),
        super(key: key) {
    _loadingMoreWidgets = slivers
        .where((x) {
          return x is LoadingMoreSliverList;
        })
        .map<LoadingMoreSliverList>((f) => f as LoadingMoreSliverList)
        .toList();
  }
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
    var loadingMoreWidgets = this.widget._loadingMoreWidgets;
    print("_LoadingMoreCustomScrollViewState_build---------------");
    if (loadingMoreWidgets.length > 0) {
      var slivers = widget.slivers;
      if (widget.reverse) {
        slivers = slivers.reversed;
        loadingMoreWidgets = loadingMoreWidgets.reversed;
      }

      for (int i = 0; i < slivers.length; i++) {
        var item = slivers[i];
        widgets.add(item);
        if (item is LoadingMoreSliverList) {
          if (loadingMoreWidgets.length > 1) {
//            item.sliverListConfig.showFullScreenLoading = showFullScreenLoading;
//            showFullScreenLoading = false;
            item.sliverListConfig.showNoMore = loadingMoreWidgets.last == item;
          }
          if (widget.rebuildCustomScrollView) {
            item.sliverListConfig.sourceList.rebuild.listen(onDataChanged);
            widgets.remove(item);
            widgets.add(item.sliverListConfig
                .buildContent(context, item.sliverListConfig.sourceList));
          }

          if (item.sliverListConfig.sourceList.hasMore) {
            break;
          }
        }
      }
    } else {
      widgets = widget.reverse ? widget.slivers.reversed : widget.slivers;
    }

    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: GlowNotificationWidget(
            CustomScrollView(
              semanticChildCount: widget.semanticChildCount,
              shrinkWrap: widget.shrinkWrap,
              scrollDirection: widget.scrollDirection,
              physics: widget.physics,
              primary: widget.primary,
              cacheExtent: widget.cacheExtent,
              controller: widget.controller,
              slivers: widgets,
            ),
            showGlowLeading: widget.showGlowLeading,
            showGlowTrailing: widget.showGlowTrailing));
    // }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    //if (notification.depth != 0) return false;

    //reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      var loadingMoreWidgets = this.widget._loadingMoreWidgets;

      if (loadingMoreWidgets.length > 0) {
        if (widget.reverse) {
          loadingMoreWidgets = loadingMoreWidgets.reversed;
        }

        LoadingMoreSliverList preList;
        for (int i = 0; i < loadingMoreWidgets.length; i++) {
          var item = loadingMoreWidgets[i];

          var preListIsloading =
              preList?.sliverListConfig?.sourceList?.isLoading ?? false;

          if (!preListIsloading &&
              item.sliverListConfig.hasMore &&
              !item.sliverListConfig.isLoading &&
              !item.sliverListConfig.hasError) {
            //new one
            //in case : loadingMoreWidgets.length>1
            //setState to add next list into view
            if (preList != item && loadingMoreWidgets.length > 1) {
              //if(item.sliverListConfig.sourceList)
              setState(() {
                item.sliverListConfig.sourceList.length == 0
                    ? item.sliverListConfig.sourceList?.refresh()
                    : item.sliverListConfig.sourceList?.loadMore();
              });
            } else {
              item.sliverListConfig.sourceList.length == 0
                  ? item.sliverListConfig.sourceList?.refresh()
                  : item.sliverListConfig.sourceList?.loadMore();
            }
            break;
          }
          preList = item;
        }
      }
    }
    return false;
  }

  void onDataChanged(LoadingMoreBase data) {
    //if (data != null) {
    setState(() {});
    //}
  }
}
