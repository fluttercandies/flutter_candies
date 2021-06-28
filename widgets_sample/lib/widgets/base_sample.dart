import 'package:flutter/material.dart';
import 'package:widgets_sample/WidgetNames.dart';
import 'package:widgets_sample/widgets/Icon_sample.dart';
import 'package:widgets_sample/widgets/Image_sample.dart';
import 'package:widgets_sample/widgets/button_sample.dart';
import 'package:widgets_sample/widgets/container_sample.dart';
import 'package:widgets_sample/widgets/row_column_sample.dart';
import 'package:widgets_sample/widgets/text_sample.dart';

class BaseSample extends StatefulWidget {
  const BaseSample(this.widgetName);
  final WidgetNames widgetName;
  @override
  State<StatefulWidget> createState() => BaseSampleState();
}

class BaseSampleState extends State<BaseSample> {
  String title;

  @override
  void initState() {
    super.initState();
    title = widget.widgetName.toString().replaceAll('WidgetNames.', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title sample')),
      body: getBody(context),
    );
  }

  SampleBody sb;
  Widget getBody(BuildContext context) {
    if (sb == null) {
      switch (widget.widgetName) {
        case WidgetNames.Container:
          sb = ContainerSampleBody();
          break;
        case WidgetNames.RowColumn:
          sb = RowColumnSampleBody();
          break;
        case WidgetNames.Image:
          sb = ImageSampleBody();
          break;
        case WidgetNames.Text:
          sb = TextSampleBody();
          break;
        case WidgetNames.Icon:
          sb = IconSampleBody();
          break;
        case WidgetNames.Button:
          sb = ButtonSampleBody();
          break;
      }
    }

    sb.state = this;
    return sb.getBody(context);
  }
}

abstract class SampleBody {
  BaseSampleState state;
  @protected
  Widget getBody(BuildContext context);

  void setState(Function f) {
    // ignore: invalid_use_of_protected_member
    state.setState(() {
      f?.call();
    });
  }
}
