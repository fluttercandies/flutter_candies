## [0.2.4]

* fix issue that ut postion is not overscroll actually,it get minimal value
  and will scroll inner positions
  igore  minimal value here(value like following data)
  /// I/flutter (14963): 5.684341886080802e-14
  /// I/flutter (14963): -5.684341886080802e-14
  if (innerDelta != 0.0 && innerDelta.abs() > 0.0001) {
  for (_NestedScrollPosition position in _activedInnerPositions) {
        position.applyFullDragUpdate(innerDelta);
     }
   }

## [0.2.0]

* update new extended_nested_scroll_view demo

## [0.1.9]

* set keepOnlyOneInnerNestedScrollPositionActive default value: false

## [0.1.8]

* update new ExtendedNestedScrollView readme

## [0.1.7]

* add assert for keepOnlyOneInnerNestedScrollPositionActive
    ///when ExtendedNestedScrollView body has [TabBarView]/[PageView] and children have
    ///AutomaticKeepAliveClientMixin or PageStorageKey,
    ///[_innerController.nestedPositions] will have more one,
    ///when you scroll, it will scroll all of nestedPositions
    ///set [keepOnlyOneInnerNestedScrollPositionActive] true to avoid it.
    ///notice: only for Axis.horizontal [TabBarView]/[PageView] and
    ///[scrollDirection] must be Axis.vertical.
assert(!(widget.keepOnlyOneInnerNestedScrollPositionActive && widget.scrollDirection == Axis.horizontal));

## [0.1.6]

* fix issue: Actived [_NestedScrollPosition] is not right for multiple

## [0.1.5]

* add new ExtendedNestedScrollView to slove issue more smartly.

## [0.1.4]

* Update readme.

## [0.1.3]

* Update demo.

## [0.1.2]

* Remove unused method.

## [0.1.1]

* Update demo.

## [0.1.0]

* Upgrade Some Commments.

## [0.0.1]

* Initial Open Source release.
