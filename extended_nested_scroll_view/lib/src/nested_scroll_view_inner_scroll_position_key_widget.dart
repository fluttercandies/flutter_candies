//pack your inner scrollables which are in  NestedScrollView body
//so that it can find the active scrollable
//compare with NestedScrollViewInnerScrollPositionKeyBuilder
import 'package:flutter/material.dart';

class NestedScrollViewInnerScrollPositionKeyWidget extends StatefulWidget {
  final Key scrollPositionKey;
  final Widget child;
  NestedScrollViewInnerScrollPositionKeyWidget(
      this.scrollPositionKey, this.child);

  static State of(BuildContext context) {
    return context.ancestorStateOfType(
        TypeMatcher<_NestedScrollViewInnerScrollPositionKeyWidgetState>());
  }

  @override
  _NestedScrollViewInnerScrollPositionKeyWidgetState createState() =>
      _NestedScrollViewInnerScrollPositionKeyWidgetState();
}

class _NestedScrollViewInnerScrollPositionKeyWidgetState
    extends State<NestedScrollViewInnerScrollPositionKeyWidget> {
  @override
  void initState() {
    // TODO: implement initState
    //WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.scrollPositionKey);
    return widget.child;
  }

//  @override
//  void didChangeDependencies() {
//    // TODO: implement didChangeDependencies
//    //print("didChangeDependencies"+widget.scrollPositionKey.toString());
//    super.didChangeDependencies();
//  }
//
//  @override
//  void didUpdateWidget(NestedScrollViewInnerScrollPositionKeyWidget oldWidget) {
//    // TODO: implement didUpdateWidget
//    //print("didUpdateWidget"+widget.scrollPositionKey.toString()+oldWidget.scrollPositionKey.toString());
//    super.didUpdateWidget(oldWidget);
//  }

  void _afterLayout(Duration timeStamp) {
    final RenderBox renderBox = this.context.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    print("${widget.scrollPositionKey} POSITION : $position ");
  }
}
