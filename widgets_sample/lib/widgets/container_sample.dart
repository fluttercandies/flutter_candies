import 'package:flutter/material.dart';
import 'package:widgets_sample/widgets/base_sample.dart';

// ignore_for_file: deprecated_member_use
class ContainerSampleBody extends SampleBody {
  @override
  Widget getBody(BuildContext context) {
    return
//         Container(
//          margin: const EdgeInsets.all(10.0),
//          color: const Color(0xFF00FF00),
//          width: 48.0,
//          height: 48.0,
//          child:  Text("Hello Flutter"),
//          padding:  const EdgeInsets.only(left: 6.0),
//        );
        Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
      ),
      padding: const EdgeInsets.all(8.0),
      color: Colors.teal.shade700,
      alignment: Alignment.center,
      child: Text('Hello World',
          style: Theme.of(context)
              .textTheme
              .display1
              .copyWith(color: Colors.white)),
      foregroundDecoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'http://p0.so.qhimgs1.com/bdr/200_200_/t011fa0ccaa6d22240c.jpg'),
          centerSlice: Rect.fromLTRB(270.0, 180.0, 1360.0, 730.0),
        ),
      ),
      transform: Matrix4.rotationZ(0.1),
    );
  }
}
