
import 'package:flutter/services.dart';

class ImageLoader
{
  static ByteData Bytes;
  static void LoadImage() async
  {
    Bytes = await rootBundle.load('assets/images/1CDD829184EA70D3151051B7A04EC794.gif');
  }
}