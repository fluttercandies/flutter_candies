import 'package:flutter/material.dart';
import 'package:widgets_sample/widgets/base_sample.dart';

class ContainerSampleBody extends SampleBody {
  @override
  Widget getBody(BuildContext context) {
    // TODO: implement getBody
    return
//        new Container(
//          margin: const EdgeInsets.all(10.0),
//          color: const Color(0xFF00FF00),
//          width: 48.0,
//          height: 48.0,
//          child: new Text("Hello Flutter"),
//          padding:  const EdgeInsets.only(left: 6.0),
//        );
        new Container(
          constraints: new BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
          ),
          padding: const EdgeInsets.all(8.0),
          color: Colors.teal.shade700,
          alignment: Alignment.center,
          child: new Text('Hello World', style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white)),
          foregroundDecoration: new BoxDecoration(
            image: new DecorationImage(
              image: new NetworkImage('http://p0.so.qhimgs1.com/bdr/200_200_/t011fa0ccaa6d22240c.jpg'),
              centerSlice: new Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
            ),
          ),
          transform: new Matrix4.rotationZ(0.1),
        );
  }
}
