import 'package:flutter/material.dart';
import 'package:loading_more_list/indicator_widget.dart';
import 'package:loading_more_list/loading_more_base.dart';

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
          itemCount: source.length + 1,
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
          itemCount: source.length + 1,
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
  bool showFullScreenLoading = true;

  //auto add sliver into a customscrollivew
  //final bool addIntoCustomScrollView;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  //final List<LoadingMoreBase<T>> sourceLists;

  SliverListConfig(
    @required itemBuilder,
    @required sourceList, {
    //this.showNoMore: true,
    //this.addIntoCustomScrollView: false,
    LoadingMoreIndicatorBuilder indicatorBuilder,
    SliverGridDelegate gridDelegate,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    //this.sourceLists,
  }) : super(itemBuilder, sourceList,
            indicatorBuilder: indicatorBuilder, gridDelegate: gridDelegate) {}

  @override
  Widget buildContent(BuildContext context, LoadingMoreBase<T> source) {
    // TODO: implement BuilderContent
    //first load
    if (source == null) {
      sourceList.onRefresh();
    }

    if (!showFullScreenLoading && source == null && sourceList.hasMore) {
      return SliverToBoxAdapter(
        child: indicatorBuilder != null
            ? indicatorBuilder(context, IndicatorStatus.LoadingMoreBusying)
            : IndicatorWidget(
                IndicatorStatus.LoadingMoreBusying,
              ),
      );
    }
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
    if (gridDelegate != null) {
      widget = SliverGrid(
          delegate: new SliverChildBuilderDelegate(buildItem,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
              semanticIndexCallback: semanticIndexCallback,
              semanticIndexOffset: semanticIndexOffset,
              childCount: source.length + lastOne),
          gridDelegate: gridDelegate);
    } else {
      widget = SliverList(
        delegate: new SliverChildBuilderDelegate(buildItem,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
            childCount: source.length + lastOne),
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
    //full screen loading
    if (source == null) {
      //first load
      sourceList.onRefresh();
      if (indicatorBuilder != null)
        return indicatorBuilder(context, IndicatorStatus.FullScreenBusying);
      return IndicatorWidget(
        IndicatorStatus.FullScreenBusying,
        isSliver: isSliver,
      );
    }
    //show list
    //else if (source.length > 0) {

    // }
    //empty
    else if (source.length == 0) {
      var widget = buildErrorItem(context);
      if (widget != null) return widget;

      if (indicatorBuilder != null)
        return indicatorBuilder(context, sourceList.indicatorStatus);
      return IndicatorWidget(
        sourceList.indicatorStatus,
        isSliver: isSliver,
      );
    }

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

      if (indicatorBuilder != null) return indicatorBuilder(context, status);
      return IndicatorWidget(
        status,
        isSliver: isSliver,
      );
    }
    return itemBuilder(context, sourceList[index], index);
  }

  Widget buildErrorItem(BuildContext context) {
    var hasError = sourceList.indicatorStatus == IndicatorStatus.Error;
    if (hasError) {
      if (indicatorBuilder != null)
        return indicatorBuilder(context, IndicatorStatus.Error);
      return IndicatorWidget(
        IndicatorStatus.Error,
        isSliver: isSliver,
        tryAgain: () {
          sourceList.onRefresh();
        },
      );
    }
    return null;
  }

  bool get hasMore => sourceList.hasMore;
}

typedef LoadingMoreIndicatorBuilder = Widget Function(
    BuildContext context, IndicatorStatus status);
