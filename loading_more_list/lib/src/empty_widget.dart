import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String msg;
  final Widget emptyWidget;
  EmptyWidget(this.msg, {this.emptyWidget});
  @override
  Widget build(BuildContext context) {
    if (emptyWidget != null) return emptyWidget;
    return Container(
      color: Colors.grey[200],
      margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 180.0,
                width: 180.0,
                child: Image.asset(
                  //https://flutter.io/docs/development/ui/assets-and-images
                  "assets/empty.jpeg",
//                  theme.brightness == Brightness.dark
//                      ? "assets/empty_dark.png"
//                      : "assets/empty_light.png",
                  package: "loading_more_list",
                )),
            Text(
              msg,
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
