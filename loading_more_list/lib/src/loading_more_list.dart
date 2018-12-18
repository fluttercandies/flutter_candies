import 'package:flutter/material.dart';
import 'package:loading_more_list/src/glow_notification_widget.dart';
import 'package:loading_more_list/src/list_config.dart';
import 'package:loading_more_list/src/loading_more_base.dart';

//loading more for listview and gridview
class LoadingMoreList<T> extends StatelessWidget {
  final ListConfig<T> listConfig;

  LoadingMoreList(this.listConfig, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadingMoreBase>(
      builder: (d, s) {
        return GlowNotificationWidget(
          NotificationListener<OverscrollIndicatorNotification>(
              onNotification: _handleGlowNotification,
              child: listConfig.buildContent(context, s.data)),
          showGlowLeading: listConfig.showGlowLeading,
          showGlowTrailing: listConfig.showGlowTrailing,
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
      if (listConfig.hasMore && !listConfig.hasError && !listConfig.isLoading) {
        listConfig.sourceList.length == 0
            ? listConfig.sourceList?.refresh()
            : listConfig.sourceList?.loadMore();
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
