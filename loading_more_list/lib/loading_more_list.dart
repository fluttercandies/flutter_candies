library loading_more_list;

import 'package:flutter/material.dart';
import 'package:loading_more_list/list_config.dart';
import 'package:loading_more_list/loading_more_base.dart';

class LoadingMoreList<T> extends StatelessWidget {
  final ListConfig<T> listConfig;

  final SliverListConfig<T> sliverListConfig;

  LoadingMoreBase<T> get loadingMoreBase {
    return listConfig?.sourceList ?? sliverListConfig?.sourceList;
  }

  LoadingMoreListConfig<T> get loadingMoreListConfig {
    return listConfig ?? sliverListConfig;
  }

  LoadingMoreList(this.listConfig, this.sliverListConfig, {Key key})
      : super(key: key) {
    //it should have one conifg
    assert(!(listConfig == null && sliverListConfig == null));
    //and it should't have two config
    assert(!(listConfig != null && sliverListConfig != null));
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadingMoreBase>(
      builder: (d, s) {
        return NotificationListener<ScrollNotification>(
          //key: _key,
          onNotification: _handleScrollNotification,
          child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: _handleGlowNotification,
              child: loadingMoreListConfig.buildContent(context, s.data)),
        );
      },
      stream: loadingMoreBase.rebuild,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    //reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.up &&
        notification.metrics.pixels + 5.0 >=
            notification.metrics.maxScrollExtent) {
      if (loadingMoreBase.hasMore) {
        loadingMoreBase.loadMore();
      }
    }
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if ((notification.leading && !loadingMoreListConfig.showGlowLeading) ||
        (!notification.leading && !loadingMoreListConfig.showGlowTrailing)) {
      notification.disallowGlow();
    }
  }
}
