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

  ListConfig(
    @required itemBuilder,
    @required sourceList, {
    bool showGlowLeading: true,
    bool showGlowTrailing: true,
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
            showGlowLeading: showGlowLeading,
            showGlowTrailing: showGlowTrailing,
            indicatorBuilder: indicatorBuilder,
            gridDelegate: gridDelegate);

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
  //only show no more for last one of slivers .
  final bool isLastOne;

  //auto add sliver into a customscrollivew
  //final bool addIntoCustomScrollView;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;

  SliverListConfig(
    @required itemBuilder,
    @required sourceList, {
    bool showGlowLeading: true,
    bool showGlowTrailing: true,
    this.isLastOne: true,
    //this.addIntoCustomScrollView: false,
    LoadingMoreIndicatorBuilder indicatorBuilder,
    SliverGridDelegate gridDelegate,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
  }) : super(itemBuilder, sourceList,
            showGlowLeading: showGlowLeading,
            showGlowTrailing: showGlowTrailing,
            indicatorBuilder: indicatorBuilder,
            gridDelegate: gridDelegate);

  @override
  Widget buildContent(BuildContext context, LoadingMoreBase<T> source) {
    // TODO: implement BuilderContent
    Widget widget = super.buildContent(context, source);
    if (widget == null) {
      int lastOne = 1;
      if (!isLastOne && !source.hasMore) {
        lastOne = 0;
      }
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
    }
    return widget;
  }
}

class LoadingMoreListConfig<T> {
  //Item builder
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

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
      {this.showGlowLeading: true,
      this.showGlowTrailing: true,
      this.indicatorBuilder,
      this.gridDelegate});

  Widget buildContent(BuildContext context, LoadingMoreBase<T> source) {
    //full screen loading
    if (source == null) {
//      if (sourceList != null) {
//        sourceList.onRefresh();
//      }
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
      if (indicatorBuilder != null)
        return indicatorBuilder(context, IndicatorStatus.Empty);
      return IndicatorWidget(
        IndicatorStatus.Empty,
        isSliver: isSliver,
      );
    }

    return null;
  }

  Widget buildItem(BuildContext context, int index) {
    if (index == sourceList.length) {
      if (sourceList.hasMore) {
        sourceList.loadMore();
      }
      var status = sourceList.hasMore
          ? IndicatorStatus.LoadingMoreBusying
          : IndicatorStatus.NoMoreLoad;

//      //if it is not last one, it show not show no more.
//      if (isSliver && status == IndicatorStatus.NoMoreLoad) {
//        var sliver = this as SliverListConfig<T>;
//        if (!sliver.isLastOne) {
//          status = IndicatorStatus.None;
//        }
//      }

      if (indicatorBuilder != null) return indicatorBuilder(context, status);
      return IndicatorWidget(
        status,
        isSliver: isSliver,
      );
    }
    return itemBuilder(context, sourceList[index], index);
  }
}

typedef LoadingMoreIndicatorBuilder = Widget Function(
    BuildContext context, IndicatorStatus status);
