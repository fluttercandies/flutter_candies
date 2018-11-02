import 'package:flutter/material.dart';
import 'package:widgets_sample/Common/my_flutter_app_icons.dart';
import 'package:widgets_sample/widgets/base_sample.dart';

class IconSampleBody extends SampleBody {
  @override
  Widget getBody(BuildContext context) {
    return new Column(
      children: <Widget>[
        Icon(Icons.add),
        Icon(MyFlutterApp.spin3),
        IconButton(icon: Icon(Icons.list), onPressed: () => {})
      ],
    );
  }
}
