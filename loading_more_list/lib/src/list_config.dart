import 'package:flutter/material.dart';
import 'package:loading_more_list/src/indicator_widget.dart';
import 'package:loading_more_list/src/loading_more_base.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) {
  return localIndex;
}

//config for ListView and GridView
class ListConfig<T> extends LoadingMoreListConfig<T> {
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final double itemExtent;
  final int itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double cacheExtent;
  final int semanticChildCount;

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

  ListConfig(
    @required itemBuilder,
    @required sourceList, {
    this.showGlowLeading: true,
    this.showGlowTrailing: true,
    LoadingMoreIndicatorBuilder indicatorBuilder,
    SliverGridDelegate gridDelegate,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.itemCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
  }) : super(itemBuilder, sourceList,
            indicatorBuilder: indicatorBuilder, gridDelegate: gridDelegate);

  @override
  Widget buildContent(BuildContext context, LoadingMoreBase<T> source) {
    // TODO: implement BuilderContent
    Widget widget = super.buildContent(context, source);

    if (widget == null) {
      var count = itemCount ?? source.length;
      if (gridDelegate != null) {
        widget = GridView.builder(
          gridDelegate: gridDelegate,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          itemBuilder: buildItem,
          itemCount: count + 1,
        );
      } else {
        widget = ListView.builder(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemExtent: itemExtent,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          itemBuilder: buildItem,
          itemCount: count + 1,
        );
      }
    }
    return widget;
  }
}

//config for SliverList and SliverGrid
class SliverListConfig<T> extends LoadingMoreListConfig<T> {
  //whether show no more  .
  bool showNoMore = true;
  //whether show fullscreenLoading for multiple sliver
  //bool showFullScreenLoading = true;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  final int childCount;

  SliverListConfig(
    @required itemBuilder,
    @required sourceList, {
    LoadingMoreIndicatorBuilder indicatorBuilder,
    SliverGridDelegate gridDelegate,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.childCount,
  }) : super(itemBuilder, sourceList,
            indicatorBuilder: indicatorBuilder, gridDelegate: gridDelegate);

  @override
  Widget buildContent(BuildContext context, LoadingMoreBase<T> source) {
    // TODO: implement BuilderContent
    //handle multiple sliver list in case showFullScreenLoading is false
//    if (!showFullScreenLoading &&
//        (source == null ||
//            (source.length == 0 &&
//                source.indicatorStatus == IndicatorStatus.FullScreenBusying))) {
//      if (source == null || !source.isLoading) {
//        //first load
//        sourceList.refresh();
//      }
//      Widget widget = null;
//      if (indicatorBuilder != null)
//        widget = indicatorBuilder(context, IndicatorStatus.LoadingMoreBusying);
//      widget = widget ??
//          IndicatorWidget(
//            IndicatorStatus.LoadingMoreBusying,
//          );
//
//      return SliverToBoxAdapter(
//        child: widget,
//      );
//    }
    return _innerBuilderContent(context, source);
  }

  Widget _innerBuilderContent(
    BuildContext context,
    LoadingMoreBase<T> source,
  ) {
    Widget widget = super.buildContent(context, source);
    if (widget == null) {
      int lastOne = 1;
      if (!showNoMore && !source.hasMore) {
        lastOne = 0;
      }
      widget = _innerBuilderList(context, source, lastOne);
    }
    return widget;
  }

  Widget _innerBuilderList(
      BuildContext context, LoadingMoreBase<T> source, int lastOne) {
    Widget widget;
    var count = childCount ?? source.length;
    if (gridDelegate != null) {
      widget = SliverGrid(
          delegate: new SliverChildBuilderDelegate(buildItem,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
              semanticIndexCallback: semanticIndexCallback,
              semanticIndexOffset: semanticIndexOffset,
              childCount: count + lastOne),
          gridDelegate: gridDelegate);
    } else {
      widget = SliverList(
        delegate: new SliverChildBuilderDelegate(buildItem,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
            childCount: count + lastOne),
      );
    }
    return widget;
  }
}

class LoadingMoreListConfig<T> {
  //Item builder
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  //source list
  final LoadingMoreBase<T> sourceList;

  //widget builder for builder different status
  //the deafault is LoadingIndicatorWidget
  final LoadingMoreIndicatorBuilder indicatorBuilder;

  //whether is gird view
  final SliverGridDelegate gridDelegate;

  bool get isSliver {
    return this is SliverListConfig<T>;
  }

  LoadingMoreListConfig(@required this.itemBuilder, @required this.sourceList,
      {this.indicatorBuilder, this.gridDelegate})
      : assert(itemBuilder != null),
        assert(sourceList != null);

  Widget buildContent(BuildContext context, LoadingMoreBase<T> source) {
    //from stream builder or from refresh
    if (source == null ||
        (source.length == 0 &&
            source.indicatorStatus == IndicatorStatus.FullScreenBusying)) {
      if (source == null || !source.isLoading) {
        //first load
        sourceList.refresh();
      }
      Widget widget = null;
      if (indicatorBuilder != null)
        widget = indicatorBuilder(context, IndicatorStatus.FullScreenBusying);
      widget = widget ??
          IndicatorWidget(
            IndicatorStatus.FullScreenBusying,
            isSliver: isSliver,
          );

      return widget;
    }
    //empty
    else if (source.length == 0 &&
            source.indicatorStatus == IndicatorStatus.Empty ||
        source.indicatorStatus == IndicatorStatus.FullScreenError) {
      Widget widget1 = null;
      if (indicatorBuilder != null)
        widget1 = indicatorBuilder(context, sourceList.indicatorStatus);
      widget1 = widget1 ??
          IndicatorWidget(
            sourceList.indicatorStatus,
            isSliver: isSliver,
            tryAgain: source.indicatorStatus == IndicatorStatus.FullScreenError
                ? () {
                    sourceList.errorRefresh();
                  }
                : null,
          );
      return widget1;
    }
    //show list
    //else if (source.length > 0) {

    // }
    return null;
  }

  Widget buildItem(BuildContext context, int index) {
    if (index == sourceList.length) {
      var widget = buildErrorItem(context);
      if (widget != null) return widget;

      var status = sourceList.hasMore
          ? IndicatorStatus.LoadingMoreBusying
          : IndicatorStatus.NoMoreLoad;

      if (sourceList.hasMore) {
        sourceList.loadMore();
      }

      Widget widget1 = null;
      if (indicatorBuilder != null) widget1 = indicatorBuilder(context, status);
      widget1 = widget1 ??
          IndicatorWidget(
            status,
            isSliver: isSliver,
          );
      return widget1;
    }
    return itemBuilder(context, sourceList[index], index);
  }

  Widget buildErrorItem(BuildContext context) {
    var hasError = sourceList.indicatorStatus == IndicatorStatus.Error;
    if (hasError) {
      Widget widget = null;
      if (indicatorBuilder != null)
        widget = indicatorBuilder(context, IndicatorStatus.Error);
      widget = widget ??
          IndicatorWidget(IndicatorStatus.Error, isSliver: isSliver,
              tryAgain: () {
            sourceList.errorRefresh();
          });
      return widget;
    }
    return null;
  }

  bool get hasMore => sourceList.hasMore;
  bool get hasError => sourceList.hasError;
  bool get isLoading =>sourceList.isLoading;
}

typedef LoadingMoreIndicatorBuilder = Widget Function(
    BuildContext context, IndicatorStatus status);
