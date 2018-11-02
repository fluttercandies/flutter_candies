import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets_sample/widgets/base_sample.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class ImageSampleBody extends SampleBody {
  Future<File> _getLocalFile(String filename) async {

   String dir = (await getApplicationDocumentsDirectory()).path;
//   File f = new File('$dir/$filename');
//   return f;

    //save a file to local
   File imgFile =new File('$dir/1234.jpg');
   imgFile.writeAsBytes((await loadImage(filename)).asUint8List());
   return imgFile;
  }

  Future<ByteBuffer> loadImage(String filename) async {
    return (await rootBundle
            .load(filename))
        .buffer;
  }

  @override
  Widget getBody(BuildContext context) {
    // TODO: implement getBody
//
//    PaintingBinding.instance.imageCache.clear();
//    PaintingBinding.instance.imageCache.maximumSize=500;
//    PaintingBinding.instance.imageCache.maximumSizeBytes=1000;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image.network(
              "http://p0.so.qhimgs1.com/bdr/200_200_/t011fa0ccaa6d22240c.jpg"),
          Image.asset("assets/images/1CDD829184EA70D3151051B7A04EC794.gif"),
          Image.asset("assets/images/4BFB73F6F47754A842565F3312619E7D.jpg"),
          FadeInImage.assetNetwork(
              placeholder: "4BFB73F6F47754A842565F3312619E7D.jpg",
              image:
                  "http://p0.so.qhimgs1.com/bdr/200_200_/t011fa0ccaa6d22240c.jpg"),
          //Image.memory(ImageLoader.Bytes),
          new FutureBuilder(
              future: _getLocalFile("assets/images/20180717125724_3342.jpg"),
              builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                return snapshot.data != null
                    ? new Image.file(snapshot.data)
                    : new Container();
              }),
          new FutureBuilder(
              future: loadImage('assets/images/56B4F4F3886539DAE8D2F3C323B69257.png'),
              builder:
                  (BuildContext context, AsyncSnapshot<ByteBuffer> snapshot) {
                return new Image.memory(snapshot.data.asUint8List());
              })
        ],
      ),
    );
  }
}
