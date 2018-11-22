import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String msg;
  final Widget emptyWidget;
  EmptyWidget(this.msg, {this.emptyWidget});
  @override
  Widget build(BuildContext context) {
    if (emptyWidget != null) return emptyWidget;
    var theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 180.0,
                width: 180.0,
                child: Image.asset(theme.brightness == Brightness.dark
                    ? "assets/images/empty_dark.png"
                    : "assets/images/empty_light.png")),
            Text(
              msg,
              style: TextStyle(
                  color: theme.brightness == Brightness.dark
                      ? Color(0xFF171717)
                      : Color(0xFFeeeeee)),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
