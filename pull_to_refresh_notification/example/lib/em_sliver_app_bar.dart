import 'dart:math';

import 'package:flutter/material.dart';

class EmSliverAppBar extends StatefulWidget {
  final Color backgroundColor;
  final double expandedHeight;
  final List<Widget> actions;
  final Widget leading;
  final Widget title;
  final Widget background;
  EmSliverAppBar(
      {this.backgroundColor,
      this.expandedHeight,
      this.actions,
      this.leading,
      this.title,
      this.background});
  @override
  _EmSliverAppBarState createState() => _EmSliverAppBarState();
}

class _EmSliverAppBarState extends State<EmSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    var topPadding = MediaQuery.of(context).padding.top;
    return SliverPersistentHeader(
      pinned: true,
      delegate: EmSliverPersistentHeaderDelegate(
        background: widget.background,
        backgroundColor: widget.backgroundColor,
        expandedHeight: widget.expandedHeight,
        title: widget.title,
        actions: widget.actions,
        leading: widget.leading,
        topPadding: topPadding,
      ),
    );
  }
}

class EmSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final double expandedHeight;
  final List<Widget> actions;
  final Widget leading;
  final Widget title;
  final Widget background;
  final double topPadding;
  EmSliverPersistentHeaderDelegate(
      {this.backgroundColor,
      this.expandedHeight,
      this.actions,
      this.leading,
      this.title,
      this.background,
      this.topPadding});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final ThemeData themeData = Theme.of(context);
    var offset = -shrinkOffset;
    // TODO: implement build
    List<Widget> rowChild = new List<Widget>();
    rowChild.add(leading ?? Container());
    rowChild.addAll(actions);

    var color = backgroundColor ?? themeData.primaryColor;
    //color = color.withOpacity(shrinkOffset / expandedHeight);
//    print((shrinkOffset + kToolbarHeight + topPadding));
//    print(shrinkOffset);
    //SliverAppBar(flexibleSpace: FlexibleSpaceBar(),)
    var child = Container(
      //height: expandedHeight,
      child: Stack(
        //fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: offset,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: background ?? Container(),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Opacity(
              opacity: (shrinkOffset/ (maxExtent-minExtent)).clamp(0.0, 1.0),
              child: Container(
                padding: EdgeInsets.only(top: topPadding),
                alignment: Alignment.center,
                color: color,
                height: kToolbarHeight + topPadding,
                child: title,
              ),
            ),
          ),
          Positioned(
            top: topPadding,
            left: 0.0,
            right: 0.0,
            child: Container(
                //color: color,
                height: kToolbarHeight,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: rowChild)),
          )
        ],
      ),
    );

    return ClipRect(
      child: child,
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => expandedHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => kToolbarHeight + topPadding;

  @override
  bool shouldRebuild(EmSliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return expandedHeight != oldDelegate.expandedHeight;
  }
}
