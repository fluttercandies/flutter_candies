import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuarkWindowCheck extends StatefulWidget {
  const QuarkWindowCheck({
    Key key,
    @required this.children,
    this.page,
  }) : super(key: key);
  final List<Widget> children;
  final int page;
  @override
  _QuarkWindowCheckState createState() => _QuarkWindowCheckState();
}

class _QuarkWindowCheckState extends State<QuarkWindowCheck>
    with TickerProviderStateMixin {
  AnimationController animationController;
  // 一个换粗你的 offset
  double tempOffset = 0.0;
  // 窗口的其起始位置
  int _position = 0;
  // 窗口范围
  final int _capacity = 5;

  List<Widget> _children;

  List<double> offsetList = [
    160, //
    360, // 160+200
    600, //360+240
    880, //600+280
    1200, //880+320
  ];
  void scroll(double dy) {
    // Log.d(dy);
    if (offsetList[1] > 160) {
      offsetList[0] += dy * 160 / 160;
      offsetList[0] = max(offsetList[0], 0);
      if (offsetList[0] > 160) {
        offsetList[0] = 160;
        return;
      }
    }
    offsetList[1] += dy * 200 / 160;
    offsetList[1] = max(offsetList[1], 0);
    offsetList[2] += dy * 240 / 160;
    offsetList[2] = max(offsetList[2], 0);
    offsetList[3] += dy * 280 / 160;
    offsetList[3] = max(offsetList[3], 0);
    offsetList[4] += dy * 320 / 160;
    offsetList[4] = max(offsetList[4], 0);
    if (offsetList[1] == 0) {
      if (_position + 1 >= _children.length) {
        return;
      }
      _position += 1;
      offsetList.removeAt(0);
      offsetList.add(offsetList.last + 280);
    }
    if (offsetList[0] != 0 && _position != 0) {
      _position -= 1;
      offsetList.removeLast();
      offsetList.insert(0, 0);
    }
  }

  List<Widget> generateWidget() {
    final List<Widget> tmp = <Widget>[];
    final int start = _position;
    for (int i = start; i < min(_children.length, _position + _capacity); i++) {
      final double offset = offsetList[i - _position];
      tmp.add(
        Padding(
          padding: EdgeInsets.only(top: offset),
          child: Center(
            child: NiCardButton(
              spreadRadius: 8,
              blurRadius: 8,
              shadowColor: Colors.black,
              borderRadius: 16,
              onTap: () {
                Navigator.of(context).pop(i);
              },
              child: Material(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height * 4 / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 32.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('终端[$i]'),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    child: const Icon(Icons.clear),
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: true,
                            child: _children[i],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return tmp;
  }

  @override
  void initState() {
    super.initState();
    _children = widget.children;
    if (widget.page != null) {
      _position = (max(widget.page - 1, 0)) ?? 0;
      offsetList.removeLast();
      offsetList.insert(0, 0);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onPanDown: (DragDownDetails details) {
            animationController?.stop();
            tempOffset = 0;
          },
          onVerticalDragStart: (DragStartDetails details) {
            tempOffset = 0;
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            scroll(details.delta.dy);

            // Log.d('curOffset====>$curOffset');
            setState(() {});
          },
          onVerticalDragEnd: (DragEndDetails details) {
            final Tolerance tolerance = Tolerance(
              velocity: 1.0 /
                  (0.050 *
                      WidgetsBinding.instance.window
                          .devicePixelRatio), // logical pixels per second
              distance: 1.0 /
                  WidgetsBinding
                      .instance.window.devicePixelRatio, // logical pixels
            );
            final double start = tempOffset;
            final ClampingScrollSimulation clampingScrollSimulation =
                ClampingScrollSimulation(
              position: start,
              velocity: -details.velocity.pixelsPerSecond.dy / 2,
              tolerance: tolerance,
            );
            animationController = AnimationController(
              vsync: this,
              value: 0,
              lowerBound: double.negativeInfinity,
              upperBound: double.infinity,
            );
            animationController.reset();
            animationController.addListener(() {
              final double offset = tempOffset - animationController.value;
              scroll(offset);
              tempOffset = animationController.value;
              setState(() {});
            });
            animationController.animateWith(clampingScrollSimulation);
          },
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              ...generateWidget(),
              // SafeArea(
              //   child: Text(
              //     '${offsetList} offset${curOffset} _position->$_position',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class NiCardButton extends StatefulWidget {
  const NiCardButton({
    Key key,
    this.child,
    this.onTap,
    this.blurRadius = 4.0,
    this.shadowColor = Colors.black,
    this.borderRadius = 8.0,
    this.color,
    this.spreadRadius = 0,
    this.margin = const EdgeInsets.all(8.0),
  }) : super(key: key);
  final Widget child;
  final Function onTap;
  final double blurRadius;
  final double borderRadius;
  final double spreadRadius;
  final Color shadowColor;
  final Color color;
  final EdgeInsetsGeometry margin;
  @override
  _NiCardButtonState createState() => _NiCardButtonState();
}

class _NiCardButtonState extends State<NiCardButton>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool isOnTap = false;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // onLongPress: () {
      //   // print('sada');
      // },
      onTap: () {
        if (widget.onTap == null) {
          return;
        }
        isOnTap = false;
        setState(() {});
        Feedback.forLongPress(context);
        animationController.reverse();
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      onTapDown: (_) {
        if (widget.onTap == null) {
          return;
        }
        animationController.forward();
        Feedback.forLongPress(context);
        isOnTap = true;
        setState(() {});
      },
      onTapCancel: () {
        if (widget.onTap == null) {
          return;
        }
        animationController.reverse();
        Feedback.forLongPress(context);
        isOnTap = false;
        setState(() {});
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(
            1.0 - animationController.value * 0.05,
          ),
        child: Container(
          margin: widget.margin,
          decoration: BoxDecoration(
            color: widget.color ?? Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: widget.shadowColor.withOpacity(
                  0.04 - animationController.value * 0.04,
                ),
                offset: const Offset(0.0, 0.0), //阴影xy轴偏移量
                blurRadius: widget.blurRadius, //阴影模糊程度
                spreadRadius: widget.spreadRadius, //阴影扩散程度
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
