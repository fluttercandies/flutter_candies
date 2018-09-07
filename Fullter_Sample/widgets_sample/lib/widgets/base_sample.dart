import 'package:flutter/material.dart';

class BaseSample extends StatefulWidget
{
  String title;
  BaseSample(String title)
  {
    this.title=title;
  }
  @override
  State<StatefulWidget> createState() => new BaseSampleState(title);
}

class BaseSampleState extends State<BaseSample> {
  String title;
  BaseSampleState(String title)
  {
    this.title=title;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(title:  Text('$title sample')),
      body: getBody(),
    );
  }

  @protected
  @mustCallSuper
  Widget getBody()
  {
      return Text("$title");
  }
}