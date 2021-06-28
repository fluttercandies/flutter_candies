import 'package:flutter/material.dart';
import 'package:widgets_sample/widgets/base_sample.dart';

class RowColumnSampleBody extends SampleBody {
  @override
  Widget getBody(BuildContext context) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      child: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: const <Widget>[
          Text('Deliver features faster', textAlign: TextAlign.center),
          Text('Craft beautiful UIs', textAlign: TextAlign.center),
          FittedBox(
            fit: BoxFit.contain, // otherwise the logo will be tiny
            child: FlutterLogo(),
          ),
        ],
      ),
    );
  }
}
