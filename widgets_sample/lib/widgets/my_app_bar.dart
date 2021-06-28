import 'package:flutter/material.dart';

typedef OnMySliverAppBarScroll = void Function(double shrinkOffset);

///Sliver App bar
class MySliverAppBar extends StatefulWidget {
  const MySliverAppBar({
    this.backgroundColor,
    this.expandedHeight,
    this.action,
    this.leading,
    this.title,
    this.background,
    this.hasBottomBorder = false,
    this.fadeTitle = true,
    this.fadeAppbarBackground = true,
    this.onScroll,
  });
  final Color backgroundColor;

  final double expandedHeight;
  final Widget action;
  final Widget leading;
  final Widget title;
  final Widget background;
  final bool hasBottomBorder;
  final bool fadeTitle;
  final bool fadeAppbarBackground;
  final OnMySliverAppBarScroll onScroll;
  @override
  _MySliverAppBarState createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return SliverPersistentHeader(
      pinned: true,
      delegate: MySliverPersistentHeaderDelegate(
          background: widget.background,
          backgroundColor: widget.backgroundColor,
          expandedHeight: widget.expandedHeight,
          title: widget.title,
          action: widget.action,
          leading: widget.leading,
          topPadding: topPadding,
          hasBottomBorder: widget.hasBottomBorder,
          fadeTitle: widget.fadeTitle,
          fadeAppbarBackground: widget.fadeAppbarBackground,
          onScroll: widget.onScroll),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(
      {this.backgroundColor,
      this.expandedHeight,
      this.action,
      this.leading,
      this.title,
      this.background,
      this.topPadding,
      this.hasBottomBorder = false,
      this.fadeTitle = true,
      this.fadeAppbarBackground = true,
      this.onScroll});
  final Color backgroundColor;
  final double expandedHeight;
  final Widget action;
  final Widget leading;
  final Widget title;
  final Widget background;
  final double topPadding;
  final bool hasBottomBorder;
  final bool fadeTitle;
  final bool fadeAppbarBackground;
  final OnMySliverAppBarScroll onScroll;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final ThemeData themeData = Theme.of(context);
    final double offset = -shrinkOffset;

    onScroll?.call(shrinkOffset);

    final List<Widget> rowChild = <Widget>[];
    rowChild.add(leading ?? Container());
    rowChild.add(action ?? Container());

    Color color = backgroundColor ?? themeData.primaryColor;
    color = color.withOpacity(fadeAppbarBackground
        ? (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0) as double
        : 1.0);
    //color = color.withOpacity(shrinkOffset / expandedHeight);
//    emPrint((shrinkOffset + emKToolbarHeight + topPadding));
//    emPrint(shrinkOffset);
    //SliverAppBar(flexibleSpace: FlexibleSpaceBar(),)
    final Container child = Container(
      //height: expandedHeight,
      color: themeData.scaffoldBackgroundColor,
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
            child: Container(
              padding: EdgeInsets.only(top: topPadding),
              alignment: Alignment.center,
              color: color,
              height: kToolbarHeight + topPadding,
              child: Opacity(
                opacity: fadeTitle
                    ? (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0)
                        as double
                    : 1.0,
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
                decoration: hasBottomBorder
                    ? const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1.0)),
                        //borderRadius:  BorderRadius.all( Radius.circular(4.0)),
                      )
                    : null,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: rowChild)),
          )
        ],
      ),
    );

    return Material(
        child: ClipRect(
      child: child,
    ));
  }

  @override
  double get maxExtent => kToolbarHeight + topPadding + expandedHeight;

  @override
  double get minExtent => kToolbarHeight + topPadding;

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        action != oldDelegate.action ||
        leading != oldDelegate.leading ||
        title != oldDelegate.title ||
        backgroundColor != oldDelegate.backgroundColor ||
        background != oldDelegate.background ||
        topPadding != oldDelegate.topPadding;
  }
}

///App bar
class MyAppBar extends StatelessWidget {
  const MyAppBar({this.backgroundColor, this.action, this.leading, this.title});
  final Color backgroundColor;
  final Widget action;
  final Widget leading;
  final Widget title;
  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    final List<Widget> rowChild = <Widget>[];
    rowChild.add(leading ?? Container());
    rowChild.add(action ?? Container());
    final ThemeData themeData = Theme.of(context);
    final Color color = backgroundColor ?? themeData.primaryColor;
    final Container child = Container(
      //height: expandedHeight,
      height: kToolbarHeight + topPadding,
      color: themeData.scaffoldBackgroundColor,
      child: Stack(
        //fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: EdgeInsets.only(top: topPadding),
              alignment: Alignment.center,
              color: color,
              height: kToolbarHeight + topPadding,
              child: title,
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

    return Material(
        child: ClipRect(
      child: child,
    ));
  }
}
