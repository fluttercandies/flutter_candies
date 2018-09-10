import 'package:flutter/material.dart';
import 'package:widgets_sample/widgets/base_sample.dart';

class RowColumnSampleBody extends SampleBody {
  @override
  Widget getBody(BuildContext context) {
    // TODO: implement getBody
   return Container(
      color: Colors.red,
      width: double.infinity,
      child:new Column(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Text('Deliver features faster', textAlign: TextAlign.center),
          new Text('Craft beautiful UIs', textAlign: TextAlign.center),
          new FittedBox(
            fit: BoxFit.contain, // otherwise the logo will be tiny
            child: const FlutterLogo(),
          ),
        ],
      ) ,
    );
  }
}
