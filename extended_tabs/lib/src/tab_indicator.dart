import 'package:flutter/material.dart';

class ColorTabIndicator extends Decoration {
  ColorTabIndicator(this.color);

  /// The color and weight of the horizontal line drawn below the selected tab.
  final Color color;

  @override
  Decoration lerpFrom(Decoration a, double t) {
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    return super.lerpTo(b, t);
  }

  @override
  _ColorPainter createBoxPainter([VoidCallback onChanged]) {
    return _ColorPainter(this, onChanged);
  }
}

class _ColorPainter extends BoxPainter {
  _ColorPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final ColorTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
//    final TextDirection textDirection = configuration.textDirection;
//    final Rect indicator =
//        _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
    final Paint paint = Paint();
    //paint.blendMode = BlendMode.clear;
    paint.color = decoration.color;
    //..strokeCap = StrokeCap.round;
//    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
    canvas.drawRect(rect, paint);
//    print(rect);
//    print(indicator);
//    final RRect outer = BorderRadius.circular(6.0).resolve(textDirection).toRRect(rect);
//    final RRect inner = outer.deflate(borderSide.width);
//    print(outer);
//    print(inner);
//    final Paint paint = Paint()
//      ..color = borderSide.color;
//    canvas.drawDRRect(outer, inner, paint);
  }
}
