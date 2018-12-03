import 'package:flutter/material.dart';
import 'package:loading_more_list/list_config.dart';
import 'package:loading_more_list/loading_more_base.dart';

//loading more for listview and gridview
class LoadingMoreList<T> extends StatelessWidget {
  final ListConfig<T> listConfig;

  LoadingMoreList(this.listConfig, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadingMoreBase>(
      builder: (d, s) {
        return NotificationListener<ScrollNotification>(
          //key: _key,
          onNotification: _handleScrollNotification,
          child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: _handleGlowNotification,
              child: listConfig.buildContent(context, s.data)),
        );
      },
      stream: listConfig.sourceList?.rebuild,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    //if (notification.depth != 0) return false;

    //reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if (listConfig.hasMore) {
        listConfig.sourceList?.loadMore();
      }
    }
    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if ((notification.leading && !listConfig.showGlowLeading) ||
        (!notification.leading && !listConfig.showGlowTrailing)) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }
}
