import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

// The over-scroll distance that moves the indicator to its maximum
// displacement, as a percentage of the scrollable's container extent.
const double _kDragContainerExtentPercentage = 0.25;

// How much the scroll's drag gesture can overshoot the RefreshIndicator's
// displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

// When the scroll ends, the duration of the refresh indicator's animation
// to the RefreshIndicator's displacement.
const Duration _kIndicatorSnapDuration = Duration(milliseconds: 150);

// The duration of the ScaleTransition that starts when the refresh action
// has completed.
const Duration _kIndicatorScaleDuration = Duration(milliseconds: 200);

/// The signature for a function that's called when the user has dragged a
/// [PullToRefreshNotification] far enough to demonstrate that they want the app to
/// refresh. The returned [Future] must complete when the refresh operation is
/// finished.
///
/// Used by [PullToRefreshNotification.onRefresh].
typedef RefreshCallback = Future<bool> Function();

// The state machine moves through these modes only when the scrollable
// identified by scrollableKey has been scrolled to its min or max limit.
enum RefreshIndicatorMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  snap, // Animating to the indicator's final "displacement".
  refresh, // Running the refresh callback.
  done, // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
  error, //refresh failed
}

class PullToRefreshNotification extends StatefulWidget {
  /// Creates a refresh indicator.
  ///
  /// The [onRefresh], [child], and [notificationPredicate] arguments must be
  /// non-null. The default
  /// [displacement] is 40.0 logical pixels.
  const PullToRefreshNotification({
    Key key,
    @required this.child,
    @required this.onRefresh,
    this.color,
    this.pullBackOnRefresh: false,
    this.maxDragOffset,
    this.notificationPredicate = defaultNotificationPredicate,
    this.armedDragUpCancel = true,
  })  : assert(child != null),
        assert(onRefresh != null),
        assert(notificationPredicate != null),
        super(key: key);

  //Dragged far enough that an up event will run the onRefresh callback.
  //when use drag up,whether should cancel refresh
  final bool armedDragUpCancel;

  /// The widget below this widget in the tree.
  ///
  /// The refresh indicator will be stacked on top of this child. The indicator
  /// will appear when child's Scrollable descendant is over-scrolled.
  ///
  /// Typically a [ListView] or [CustomScrollView].
  final Widget child;

  /// A function that's called when the user has dragged the refresh indicator
  /// far enough to demonstrate that they want the app to refresh. The returned
  /// [Future] must complete when the refresh operation is finished.
  final RefreshCallback onRefresh;

  /// The progress indicator's foreground color. The current theme's
  /// /// [ThemeData.accentColor] by default. only for android
  final Color color;

  //whether start pull back animation when refresh.
  final bool pullBackOnRefresh;

  //the max drag offset
  final double maxDragOffset;

  //use in case much ScrollNotification from child
  final bool Function(ScrollNotification notification) notificationPredicate;

  @override
  PullToRefreshNotificationState createState() =>
      PullToRefreshNotificationState();
}

/// Contains the state for a [PullToRefreshNotification]. This class can be used to
/// programmatically show the refresh indicator, see the [show] method.
class PullToRefreshNotificationState extends State<PullToRefreshNotification>
    with TickerProviderStateMixin<PullToRefreshNotification> {
  final _onNoticed =
      new StreamController<PullToRefreshScrollNotificationInfo>.broadcast();
  Stream<PullToRefreshScrollNotificationInfo> get onNoticed =>
      _onNoticed.stream;

  AnimationController _positionController;
  AnimationController _scaleController;
  Animation<double> _scaleFactor;
  Animation<double> _value;
  Animation<Color> _valueColor;

  AnimationController _pullBackController;
  Animation<double> _pullBackFactor;

  RefreshIndicatorMode _mode;
  RefreshIndicatorMode get _refreshIndicatorMode => _mode;
  set _refreshIndicatorMode(value) {
    if (_mode != value) {
      _mode = value;
      _onInnerNoticed();
    }
  }

  Future<void> _pendingRefreshFuture;
  bool _isIndicatorAtTop;
  double _dragOffset;
  double get _notificationDragOffset => _dragOffset;
  set _notificationDragOffset(double value) {
    if (value != null) {
      value = math.max(
          0.0, math.min(value, widget.maxDragOffset ?? double.maxFinite));
    }
    if (_dragOffset != value) {
      _dragOffset = value;
      _onInnerNoticed();
    }
  }

  static final Animatable<double> _threeQuarterTween =
      Tween<double>(begin: 0.0, end: 0.75);
  static final Animatable<double> _oneToZeroTween =
      Tween<double>(begin: 1.0, end: 0.0);

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);

    _value = _positionController.drive(
        _threeQuarterTween); // The "value" of the circular progress indicator during a drag.

    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);

    _pullBackController = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _valueColor = _positionController.drive(
      ColorTween(
              begin: (widget.color ?? theme.accentColor).withOpacity(0.0),
              end: (widget.color ?? theme.accentColor).withOpacity(1.0))
          .chain(CurveTween(
              curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit))),
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    _pullBackController.dispose();
    _onNoticed.close();
    super.dispose();
  }

  double maxContainerExtent = 0.0;
  bool _handleScrollNotification(ScrollNotification notification) {
    var reuslt = _innerhandleScrollNotification(notification);
    //_onInnerNoticed();
    return reuslt;
  }

  bool _innerhandleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) return false;
    if (notification.depth != 0) {
      maxContainerExtent = math.max(
          notification.metrics.viewportDimension, this.maxContainerExtent);
    }
    if (notification is ScrollStartNotification &&
        notification.metrics.extentBefore == 0.0 &&
        _refreshIndicatorMode == null &&
        _start(notification.metrics.axisDirection)) {
      //setState(() {
      _mode = RefreshIndicatorMode.drag;
      //});
      return false;
    }
    bool indicatorAtTopNow;
    switch (notification.metrics.axisDirection) {
      case AxisDirection.down:
        indicatorAtTopNow = true;
        break;
      case AxisDirection.up:
        indicatorAtTopNow = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        indicatorAtTopNow = null;
        break;
    }
    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_refreshIndicatorMode == RefreshIndicatorMode.drag ||
          _refreshIndicatorMode == RefreshIndicatorMode.armed)
        _dismiss(RefreshIndicatorMode.canceled);
    } else if (notification is ScrollUpdateNotification) {
      if (_refreshIndicatorMode == RefreshIndicatorMode.drag ||
          _refreshIndicatorMode == RefreshIndicatorMode.armed) {
        if (notification.metrics.extentBefore > 0.0) {
          if (_refreshIndicatorMode == RefreshIndicatorMode.armed &&
              !widget.armedDragUpCancel) {
            _show();
          } else {
            _dismiss(RefreshIndicatorMode.canceled);
          }
        } else {
          _notificationDragOffset -= notification.scrollDelta;
          _checkDragOffset(maxContainerExtent);
        }
      }
      if (_refreshIndicatorMode == RefreshIndicatorMode.armed &&
          notification.dragDetails == null) {
        // On iOS start the refresh when the Scrollable bounces back from the
        // overscroll (ScrollNotification indicating this don't have dragDetails
        // because the scroll activity is not directly triggered by a drag).
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_refreshIndicatorMode == RefreshIndicatorMode.drag ||
          _refreshIndicatorMode == RefreshIndicatorMode.armed) {
        _notificationDragOffset -= notification.overscroll / 2.0;
        _checkDragOffset(maxContainerExtent);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_refreshIndicatorMode) {
        case RefreshIndicatorMode.armed:
          _show();
          break;
        case RefreshIndicatorMode.drag:
          _dismiss(RefreshIndicatorMode.canceled);
          break;
        default:
          // do nothing
          break;
      }
    }
    //_onInnerNoticed();
    return false;
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if (notification.depth != 0 || !notification.leading) return false;
    if (_refreshIndicatorMode == RefreshIndicatorMode.drag) {
      notification.disallowGlow();
      return true;
    }
    return false;
  }

  bool _start(AxisDirection direction) {
    assert(_refreshIndicatorMode == null);
    assert(_isIndicatorAtTop == null);
    assert(_notificationDragOffset == null);
    switch (direction) {
      case AxisDirection.down:
        _isIndicatorAtTop = true;
        break;
      case AxisDirection.up:
        _isIndicatorAtTop = false;
        break;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        // we do not support horizontal scroll views.
        return false;
    }
    _dragOffset = 0.0;
    _scaleController.value = 0.0;
    _positionController.value = 0.0;
    _pullBackFactor?.removeListener(pullBackListener);
    _pullBackController.reset();
    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(_refreshIndicatorMode == RefreshIndicatorMode.drag ||
        _refreshIndicatorMode == RefreshIndicatorMode.armed);
    double newValue = _notificationDragOffset /
        (containerExtent * _kDragContainerExtentPercentage);
    if (widget.maxDragOffset != null) {
      newValue = _notificationDragOffset / widget.maxDragOffset;
    }
    if (_refreshIndicatorMode == RefreshIndicatorMode.armed)
      newValue = math.max(newValue, 1.0 / _kDragSizeFactorLimit);
    _positionController.value =
        newValue.clamp(0.0, 1.0); // this triggers various rebuilds

    if (_refreshIndicatorMode == RefreshIndicatorMode.drag &&
        _valueColor.value.alpha == 0xFF)
      _refreshIndicatorMode = RefreshIndicatorMode.armed;
  }

  // Stop showing the refresh indicator.
  Future<void> _dismiss(RefreshIndicatorMode newMode) async {
    await Future<void>.value();
    // This can only be called from _show() when refreshing and
    // _handleScrollNotification in response to a ScrollEndNotification or
    // direction change.
    assert(newMode == RefreshIndicatorMode.canceled ||
        newMode == RefreshIndicatorMode.done);
    //setState(() {
    _refreshIndicatorMode = newMode;
    //});
    switch (_refreshIndicatorMode) {
      case RefreshIndicatorMode.done:
        await _scaleController.animateTo(1.0,
            duration: _kIndicatorScaleDuration);
        break;
      case RefreshIndicatorMode.canceled:
        await _positionController.animateTo(0.0,
            duration: _kIndicatorScaleDuration);
        break;
      default:
        assert(false);
    }
    if (mounted && _refreshIndicatorMode == newMode) {
      _notificationDragOffset = null;
      _isIndicatorAtTop = null;
      //setState(() {
      _refreshIndicatorMode = null;
      // });
    }
    //_onInnerNoticed();
  }

  void _show() {
    assert(_refreshIndicatorMode != RefreshIndicatorMode.refresh);
    assert(_refreshIndicatorMode != RefreshIndicatorMode.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _refreshIndicatorMode = RefreshIndicatorMode.snap;
    _positionController
        .animateTo(1.0 / _kDragSizeFactorLimit,
            duration: _kIndicatorSnapDuration)
        .then<void>((void value) {
      if (mounted && _refreshIndicatorMode == RefreshIndicatorMode.snap) {
        assert(widget.onRefresh != null);
        // setState(() {
        // Show the indeterminate progress indicator.
        _refreshIndicatorMode = RefreshIndicatorMode.refresh;
        //});

        final Future<bool> refreshResult = widget.onRefresh();
        assert(() {
          if (refreshResult == null)
            FlutterError.reportError(FlutterErrorDetails(
              exception: FlutterError('The onRefresh callback returned null.\n'
                  'The RefreshIndicator onRefresh callback must return a Future.'),
              context: 'when calling onRefresh',
              library: 'material library',
            ));
          return true;
        }());
        if (refreshResult == null) return;
        refreshResult.then((bool success) {
          if (mounted &&
              _refreshIndicatorMode == RefreshIndicatorMode.refresh) {
            completer.complete();
            if (success) {
              _dismiss(RefreshIndicatorMode.done);
            } else
              _refreshIndicatorMode = RefreshIndicatorMode.error;
          }
        });
      }
    });
  }

  /// Show the refresh indicator and run the refresh callback as if it had
  /// been started interactively. If this method is called while the refresh
  /// callback is running, it quietly does nothing.
  ///
  /// Creating the [PullToRefreshNotification] with a [GlobalKey<RefreshIndicatorState>]
  /// makes it possible to refer to the [PullToRefreshNotificationState].
  ///
  /// The future returned from this method completes when the
  /// [PullToRefreshNotification.onRefresh] callback's future completes.
  ///
  /// If you await the future returned by this function from a [State], you
  /// should check that the state is still [mounted] before calling [setState].
  ///
  /// When initiated in this manner, the refresh indicator is independent of any
  /// actual scroll view. It defaults to showing the indicator at the top. To
  /// show it at the bottom, set `atTop` to false.
  Future<void> show({bool atTop = true}) {
    if (_refreshIndicatorMode != RefreshIndicatorMode.refresh &&
        _refreshIndicatorMode != RefreshIndicatorMode.snap) {
      if (_refreshIndicatorMode == null)
        _start(atTop ? AxisDirection.down : AxisDirection.up);
      _show();
    }
    return _pendingRefreshFuture;
  }

  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Widget child = NotificationListener<ScrollNotification>(
      key: _key,
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification,
        child: widget.child,
      ),
    );
//    if (_Mode == null) {
//      assert(_DragOffset == null);
//      assert(_isIndicatorAtTop == null);
//      return child;
//    }
//    assert(_DragOffset != null);
//    assert(_isIndicatorAtTop != null);
//
//    final bool showIndeterminateIndicator =
//        _Mode == RefreshIndicatorMode.refresh ||
//            _Mode == RefreshIndicatorMode.done;
    return child;
    //print(_value.value);
//    return Stack(
//      children: <Widget>[
//        child,
//        Positioned(
//          top: _isIndicatorAtTop ? 0.0 : null,
//          bottom: !_isIndicatorAtTop ? 0.0 : null,
//          left: 0.0,
//          right: 0.0,
//          child: SizeTransition(
//            axisAlignment: _isIndicatorAtTop ? 1.0 : -1.0,
//            sizeFactor: _positionFactor, // this is what brings it down
//            child: Container(
//              padding: _isIndicatorAtTop
//                  ? EdgeInsets.only(top: widget.displacement)
//                  : EdgeInsets.only(bottom: widget.displacement),
//              alignment: _isIndicatorAtTop
//                  ? Alignment.topCenter
//                  : Alignment.bottomCenter,
//              child: ScaleTransition(
//                scale: _scaleFactor,
//                child: AnimatedBuilder(
//                  animation: _positionController,
//                  builder: (BuildContext context, Widget child) {
//                    return RefreshProgressIndicator(
//                      value: showIndeterminateIndicator ? null : _value.value,
//                      valueColor: _valueColor,
//                      backgroundColor: widget.backgroundColor,
//                    );
//                  },
//                ),
//              ),
//            ),
//          ),
//        ),
//      ],
//    );
  }

  void _onInnerNoticed() {
    if ((_dragOffset != null && _dragOffset > 0.0) &&
        ((_refreshIndicatorMode == RefreshIndicatorMode.done &&
                !widget.pullBackOnRefresh) ||
            (_refreshIndicatorMode == RefreshIndicatorMode.refresh &&
                widget.pullBackOnRefresh) ||
            _refreshIndicatorMode == RefreshIndicatorMode.canceled)) {
      _pullBack();
      return;
    }

    if (_pullBackController.isAnimating) {
      pullBackListener();
    } else {
      _onNoticed.add(PullToRefreshScrollNotificationInfo(_refreshIndicatorMode,
          _notificationDragOffset, _getRefreshWidget(), this));
    }
  }

  Widget _getRefreshWidget() {
    if (_refreshIndicatorMode == null) return null;
    final bool showIndeterminateIndicator =
        _refreshIndicatorMode == RefreshIndicatorMode.refresh ||
            _refreshIndicatorMode == RefreshIndicatorMode.done;
    return ScaleTransition(
      scale: _scaleFactor,
      child: AnimatedBuilder(
        animation: _positionController,
        builder: (BuildContext context, Widget child) {
          if (Platform.isIOS) {
            return CupertinoActivityIndicator(
              animating: showIndeterminateIndicator,
              radius: 10.0,
            );
          } else {
            return RefreshProgressIndicator(
              value: showIndeterminateIndicator ? null : _value.value,
              valueColor: _valueColor,
              strokeWidth: 2.0,
            );
          }
        },
      ),
    );
  }

  void pullBackListener() {
    //print(_pullBackFactor.value);
    if (_dragOffset != _pullBackFactor.value) {
      _dragOffset = _pullBackFactor.value;
      _onNoticed.add(PullToRefreshScrollNotificationInfo(
          _refreshIndicatorMode, _dragOffset, _getRefreshWidget(), this));
      if (_dragOffset == 0.0) {
        _dragOffset = null;
      }
    }
  }

  void _pullBack() {
    final Animatable<double> _pullBackTween =
        Tween<double>(begin: _notificationDragOffset ?? 0.0, end: 0.0);
    _pullBackFactor?.removeListener(pullBackListener);
    _pullBackController.reset();
    _pullBackFactor = _pullBackController.drive(_pullBackTween);
    _pullBackFactor.addListener(pullBackListener);
    _pullBackController.animateTo(1.0,
        duration: Duration(milliseconds: 400), curve: Curves.linear);
    //_DragOffset=0.0;
  }
}

//return true so that we can handle inner scroll notification
bool defaultNotificationPredicate(ScrollNotification notification) {
  return true;
  //return notification.depth == 0;
}

class PullToRefreshScrollNotificationInfo {
  final RefreshIndicatorMode mode;
  final double dragOffset;
  final Widget refreshWiget;
  final PullToRefreshNotificationState pullToRefreshNotificationState;
  PullToRefreshScrollNotificationInfo(this.mode, this.dragOffset,
      this.refreshWiget, this.pullToRefreshNotificationState);
}

class PullToRefreshContainer extends StatefulWidget {
  final PullToRefreshContainerBuilder builder;
  PullToRefreshContainer(this.builder);
  @override
  _PullToRefreshContainerState createState() => _PullToRefreshContainerState();
}

class _PullToRefreshContainerState extends State<PullToRefreshContainer> {
  @override
  Widget build(BuildContext context) {
    PullToRefreshNotificationState ss = context
        .ancestorStateOfType(TypeMatcher<PullToRefreshNotificationState>());
    return StreamBuilder<PullToRefreshScrollNotificationInfo>(
      builder: (c, s) {
        return widget.builder(s.data);
      },
      stream: ss?.onNoticed,
    );
  }
}

typedef PullToRefreshContainerBuilder = Widget Function(
    PullToRefreshScrollNotificationInfo info);

class RefreshProgressIndicator extends CircularProgressIndicator {
  /// Creates a refresh progress indicator.
  ///
  /// Rather than creating a refresh progress indicator directly, consider using
  /// a [RefreshIndicator] together with a [Scrollable] widget.
  const RefreshProgressIndicator({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
    double strokeWidth =
        2.0, // Different default than CircularProgressIndicator.
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
          strokeWidth: strokeWidth,
        );

  @override
  _RefreshProgressIndicatorState createState() =>
      _RefreshProgressIndicatorState();
}

class _RefreshProgressIndicatorState extends _CircularProgressIndicatorState {
  static const double _indicatorSize = 18.0;

  // Always show the indeterminate version of the circular progress indicator.
  // When value is non-null the sweep of the progress indicator arrow's arc
  // varies from 0 to about 270 degrees. When value is null the arrow animates
  // starting from wherever we left it.
  @override
  Widget build(BuildContext context) {
    if (widget.value != null)
      _controller.value = widget.value / 10.0;
    else if (!_controller.isAnimating) _controller.repeat();
    return _buildAnimation();
  }

  @override
  Widget _buildIndicator(BuildContext context, double headValue,
      double tailValue, int stepValue, double rotationValue) {
    final double arrowheadScale =
        widget.value == null ? 0.0 : (widget.value * 2.0).clamp(0.0, 1.0);
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: _indicatorSize,
        height: _indicatorSize,
        //color: Colors.red,
        child: CustomPaint(
          painter: _RefreshProgressIndicatorPainter(
            valueColor: widget._getValueColor(context),
            value: null, // Draw the indeterminate progress indicator.
            headValue: headValue,
            tailValue: tailValue,
            stepValue: stepValue,
            rotationValue: rotationValue,
            strokeWidth: widget.strokeWidth,
            arrowheadScale: arrowheadScale,
          ),
        ),
      ),
    );
  }
}

const double _kMinCircularProgressIndicatorSize = 36.0;

final Animatable<double> _kStrokeHeadTween = CurveTween(
  curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
).chain(CurveTween(
  curve: const SawTooth(5),
));

final Animatable<double> _kStrokeTailTween = CurveTween(
  curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
).chain(CurveTween(
  curve: const SawTooth(5),
));

final Animatable<int> _kStepTween = StepTween(begin: 0, end: 5);

final Animatable<double> _kRotationTween = CurveTween(curve: const SawTooth(5));

class CircularProgressIndicator extends ProgressIndicator {
  /// Creates a circular progress indicator.
  ///
  /// The [value] argument can be either null (corresponding to an indeterminate
  /// progress indicator) or non-null (corresponding to a determinate progress
  /// indicator). See [value] for details.
  const CircularProgressIndicator({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
    this.strokeWidth = 4.0,
  }) : super(
            key: key,
            value: value,
            backgroundColor: backgroundColor,
            valueColor: valueColor);

  /// The width of the line used to draw the circle.
  final double strokeWidth;

  @override
  _CircularProgressIndicatorState createState() =>
      _CircularProgressIndicatorState();
}

class _CircularProgressIndicatorState extends State<CircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    if (widget.value == null) _controller.repeat();
  }

  @override
  void didUpdateWidget(CircularProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating)
      _controller.repeat();
    else if (widget.value != null && _controller.isAnimating)
      _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, double headValue,
      double tailValue, int stepValue, double rotationValue) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: _kMinCircularProgressIndicatorSize,
        minHeight: _kMinCircularProgressIndicatorSize,
      ),
      child: CustomPaint(
        painter: _CircularProgressIndicatorPainter(
          valueColor: widget._getValueColor(context),
          value: widget.value, // may be null
          headValue:
              headValue, // remaining arguments are ignored if widget.value is not null
          tailValue: tailValue,
          stepValue: stepValue,
          rotationValue: rotationValue,
          strokeWidth: widget.strokeWidth,
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return _buildIndicator(
          context,
          _kStrokeHeadTween.evaluate(_controller),
          _kStrokeTailTween.evaluate(_controller),
          _kStepTween.evaluate(_controller),
          _kRotationTween.evaluate(_controller),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) return _buildIndicator(context, 0.0, 0.0, 0, 0.0);
    return _buildAnimation();
  }
}

class _RefreshProgressIndicatorPainter
    extends _CircularProgressIndicatorPainter {
  _RefreshProgressIndicatorPainter({
    Color valueColor,
    double value,
    double headValue,
    double tailValue,
    int stepValue,
    double rotationValue,
    double strokeWidth,
    this.arrowheadScale,
  }) : super(
          valueColor: valueColor,
          value: value,
          headValue: headValue,
          tailValue: tailValue,
          stepValue: stepValue,
          rotationValue: rotationValue,
          strokeWidth: strokeWidth,
        );

  final double arrowheadScale;

  void paintArrowhead(Canvas canvas, Size size) {
    // ux, uy: a unit vector whose direction parallels the base of the arrowhead.
    // (So ux, -uy points in the direction the arrowhead points.)
    final double arcEnd = arcStart + arcSweep;
    final double ux = math.cos(arcEnd);
    final double uy = math.sin(arcEnd);

    assert(size.width == size.height);
    final double radius = size.width / 2.0;
    final double arrowheadPointX =
        radius + ux * radius + -uy * strokeWidth * 2.0 * arrowheadScale;
    final double arrowheadPointY =
        radius + uy * radius + ux * strokeWidth * 2.0 * arrowheadScale;
    final double arrowheadRadius = strokeWidth * 1.5 * arrowheadScale;
    final double innerRadius = radius - arrowheadRadius;
    final double outerRadius = radius + arrowheadRadius;

    final Path path = Path()
      ..moveTo(radius + ux * innerRadius, radius + uy * innerRadius)
      ..lineTo(radius + ux * outerRadius, radius + uy * outerRadius)
      ..lineTo(arrowheadPointX, arrowheadPointY)
      ..close();
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    if (arrowheadScale > 0.0) paintArrowhead(canvas, size);
  }
}

class _CircularProgressIndicatorPainter extends CustomPainter {
  _CircularProgressIndicatorPainter({
    this.valueColor,
    this.value,
    this.headValue,
    this.tailValue,
    this.stepValue,
    this.rotationValue,
    this.strokeWidth,
  })  : arcStart = value != null
            ? _startAngle
            : _startAngle +
                tailValue * 3 / 2 * math.pi +
                rotationValue * math.pi * 1.7 -
                stepValue * 0.8 * math.pi,
        arcSweep = value != null
            ? value.clamp(0.0, 1.0) * _sweep
            : math.max(
                headValue * 3 / 2 * math.pi - tailValue * 3 / 2 * math.pi,
                _epsilon);

  final Color valueColor;
  final double value;
  final double headValue;
  final double tailValue;
  final int stepValue;
  final double rotationValue;
  final double strokeWidth;
  final double arcStart;
  final double arcSweep;

  static const double _twoPi = math.pi * 2.0;
  static const double _epsilon = .001;
  // Canvas.drawArc(r, 0, 2*PI) doesn't draw anything, so just get close.
  static const double _sweep = _twoPi - _epsilon;
  static const double _startAngle = -math.pi / 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    if (value == null) // Indeterminate
      paint.strokeCap = StrokeCap.square;

    canvas.drawArc(Offset.zero & size, arcStart, arcSweep, false, paint);
  }

  @override
  bool shouldRepaint(_CircularProgressIndicatorPainter oldPainter) {
    return oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.headValue != headValue ||
        oldPainter.tailValue != tailValue ||
        oldPainter.stepValue != stepValue ||
        oldPainter.rotationValue != rotationValue ||
        oldPainter.strokeWidth != strokeWidth;
  }
}

abstract class ProgressIndicator extends StatefulWidget {
  /// Creates a progress indicator.
  ///
  /// The [value] argument can be either null (corresponding to an indeterminate
  /// progress indicator) or non-null (corresponding to a determinate progress
  /// indicator). See [value] for details.
  const ProgressIndicator({
    Key key,
    this.value,
    this.backgroundColor,
    this.valueColor,
  }) : super(key: key);

  /// If non-null, the value of this progress indicator with 0.0 corresponding
  /// to no progress having been made and 1.0 corresponding to all the progress
  /// having been made.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicator how
  /// much actual progress is being made.
  final double value;

  /// The progress indicator's background color. The current theme's
  /// [ThemeData.backgroundColor] by default.
  final Color backgroundColor;

  /// The indicator's color is the animation's value. To specify a constant
  /// color use: `new AlwaysStoppedAnimation<Color>(color)`.
  ///
  /// If null, the progress indicator is rendered with the current theme's
  /// [ThemeData.accentColor].
  final Animation<Color> valueColor;

  Color _getValueColor(BuildContext context) =>
      valueColor?.value ?? Theme.of(context).accentColor;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', value,
        showName: false, ifNull: '<indeterminate>'));
  }
}
