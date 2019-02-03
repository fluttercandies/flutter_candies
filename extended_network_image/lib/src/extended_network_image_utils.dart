import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui show Image, PictureRecorder;

const String CacheImageFolderName = "cacheimage";

class ExtendedNetworkImageUtils {}

String toMd5(String str) => md5.convert(utf8.encode(str)).toString();

///crop image
ui.Image getCroppedImage(ui.Image image, Rect src, Rect dst) {
  var pictureRecorder = new ui.PictureRecorder();
  Canvas canvas = new Canvas(pictureRecorder);
  canvas.drawImageRect(image, src, dst, Paint());
  return pictureRecorder
      .endRecording()
      .toImage(dst.width.floor(), dst.height.floor());
}

/// Clear the disk cache directory then return if it succeed.
///  <param name="duration">timespan to compute whether file has expired or not</param>
Future<bool> clearDiskCachedImages({Duration duration}) async {
  try {
    Directory _cacheImagesDirectory = Directory(
        join((await getTemporaryDirectory()).path, CacheImageFolderName));
    if (duration == null) {
      _cacheImagesDirectory.deleteSync(recursive: true);
    } else {
      var now = DateTime.now();
      for (var file in _cacheImagesDirectory.listSync()) {
        FileStat fs = file.statSync();
        if (now.subtract(duration).isAfter(fs.changed)) {
          print("remove expired cached image");
          file.deleteSync(recursive: true);
        }
      }
    }
  } catch (_) {
    return false;
  }
  return true;
}

/// This image is a detector.
Uint8List emptyImage = Uint8List.fromList([
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  6,
  0,
  0,
  0,
  31,
  21,
  196,
  137,
  0,
  0,
  0,
  4,
  115,
  66,
  73,
  84,
  8,
  8,
  8,
  8,
  124,
  8,
  100,
  136,
  0,
  0,
  0,
  11,
  73,
  68,
  65,
  84,
  8,
  153,
  99,
  248,
  15,
  4,
  0,
  9,
  251,
  3,
  253,
  227,
  85,
  242,
  156,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130
]);

Uint8List emptyImage2 = Uint8List.fromList([
  137,
  80,
  78,
  71,
  13,
  10,
  26,
  10,
  0,
  0,
  0,
  13,
  73,
  72,
  68,
  82,
  0,
  0,
  0,
  1,
  0,
  0,
  0,
  1,
  8,
  6,
  0,
  0,
  0,
  31,
  21,
  196,
  137,
  0,
  0,
  0,
  1,
  115,
  82,
  71,
  66,
  0,
  174,
  206,
  28,
  233,
  0,
  0,
  0,
  4,
  115,
  66,
  73,
  84,
  8,
  8,
  8,
  8,
  124,
  8,
  100,
  136,
  0,
  0,
  0,
  11,
  73,
  68,
  65,
  84,
  8,
  153,
  99,
  248,
  15,
  4,
  0,
  9,
  251,
  3,
  253,
  227,
  85,
  242,
  156,
  0,
  0,
  0,
  0,
  73,
  69,
  78,
  68,
  174,
  66,
  96,
  130
]);
