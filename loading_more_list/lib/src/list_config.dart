import 'package:flutter/material.dart';
import 'package:loading_more_list/src/indicator_widget.dart';
import 'package:loading_more_list/src/loading_more_base.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) {
  return localIndex;
}

//config for ListView and GridView
class ListConfig<T> extends LoadingMoreListConfig<T> {
  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  final ScrollController controller;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// When this is true, the scroll view is scrollable even if it does not have
  /// sufficient content to actually scroll. Otherwise, by default the user can
  /// only scroll the view if it has sufficient content. See [physics].
  ///
  /// On iOS, this also identifies the scroll view that will scroll to top in
  /// response to a tap in the status bar.
  ///
  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [controller] is null.
  final bool primary;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions. Furthermore, if [primary] is
  /// false, then the user cannot scroll if there is insufficient content to
  /// scroll, while if [primary] is true, they can always attempt to scroll.
  ///
  /// To force the scroll view to always be scrollable even if there is
  /// insufficient content, as if [primary] was true but without necessarily
  /// setting it to true, provide an [AlwaysScrollableScrollPhysics] physics
  /// object, as in:
  ///
  /// ```dart
  ///   physics: const AlwaysScrollableScrollPhysics(),
  /// ```
  ///
  /// To force the scroll view to use the default platform conventions and not
  /// be scrollable if there is insufficient content, regardless of the value of
  /// [primary], provide an explicit [ScrollPhysics] object, as in:
  ///
  /// ```dart
  ///   physics: const ScrollPhysics(),
  /// ```
  ///
  /// The physics can be changed dynamically (by providing a new object in a
  /// subsequent build), but new physics will only take effect if the _class_ of
  /// the provided object changes. Merely constructing a new instance with a
  /// different configuration is insufficient to cause the physics to be
  /// reapplied. (This is because the final object used is generated
  /// dynamically, which can be relatively expensive, and it would be
  /// inefficient to speculatively create this object each frame to see if the
  /// physics should be updated.)
  final ScrollPhysics physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// {@macro flutter.rendering.viewport.cacheExtent}
  final double cacheExtent;

  /// The number of children that will contribute semantic information.
  ///
  /// Some subtypes of [ScrollView] can infer this value automatically. For
  /// example [ListView] will use the number of widgets in the child list,
  /// while the [new ListView.separated] constructor will use half that amount.
  ///
  /// For [CustomScrollView] and other types which do not receive a builder
  /// or list of widgets, the child count must be explicitly provided. If the
  /// number is unknown or unbounded this should be left unset or set to null.
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.scrollChildCount], the corresponding semantics property.
  final int semanticChildCount;

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry padding;

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use of
  /// the foreknowledge of the children's extent to save work, for example when
  /// the scroll position changes drastically.
  final double itemExtent;

  /// The total number of children this delegate can provide.
  ///
  /// If null, the number of children is determined by the least index for which
  /// [builder] returns null.
  final int itemCount;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// Typically, children in lazy list are wrapped in [AutomaticKeepAlive]
  /// widgets so that children can use [KeepAliveNotification]s to preserve
  /// their state when they would otherwise be garbage collected off-screen.
  ///
  /// This feature (and [addRepaintBoundaries]) must be disabled if the children
  /// are going to manually maintain their [KeepAlive] state. It may also be
  /// more efficient to disable this feature if it is known ahead of time that
  /// none of the children will ever try to keep themselves alive.
  ///
  /// Defaults to true.
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// Typically, children in a scrolling container are wrapped in repaint
  /// boundaries so that they do not need to be repainted as the list scrolls.
  /// If the children are easy to repaint (e.g., solid color blocks or a short
  /// snippet of text), it might be more efficient to not add a repaint boundary
  /// and simply repaint the children during scrolling.
  ///
  /// Defaults to true.
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// Typically, children in a scrolling container must be annotated with a
  /// semantic index in order to generate the correct accessibility
  /// announcements. This should only be set to false if the indexes have
  /// already been provided by an [IndexedChildSemantics] widget.
  ///
  /// Defaults to true.
  ///
  /// See also:
  ///
  ///  * [IndexedChildSemantics], for an explanation of how to manually
  ///    provide semantic indexes.
  final bool addSemanticIndexes;

  ListConfig({
    Widget Function(BuildContext context, T item, int index) itemBuilder,
    LoadingMoreBase<T> sourceList,
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
    this.padding = const EdgeInsets.all(0.0),
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

  SliverListConfig({
    Widget Function(BuildContext context, T item, int index) itemBuilder,
    LoadingMoreBase<T> sourceList,
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

  LoadingMoreListConfig(this.itemBuilder, this.sourceList,
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
  bool get isLoading => sourceList.isLoading;
}

typedef LoadingMoreIndicatorBuilder = Widget Function(
    BuildContext context, IndicatorStatus status);
