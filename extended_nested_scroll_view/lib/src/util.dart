import 'package:flutter/widgets.dart';

///get type from T
Type typeOf<T>() => T;

bool isInSameTree(RenderObject child, RenderObject parent) {
  if (parent == null || child == null) return true;
  var temp = child;
  while (temp != null) {
    if (temp == parent) return true;
    temp = temp.parent;
  }
  return false;
}