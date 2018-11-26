import 'package:example/common/tu_chong_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:flutter_advanced_networkimage/transition_to_image.dart';
class ItemBuilder
{
  static Widget itemBuilder(BuildContext context, TuChongItem item, int index) {
    return Container(
      height: 200.0,
      child: Stack(
        children: <Widget>[
          Positioned(
            child: TransitionToImage(
              AdvancedNetworkImage(
                item.imageUrl,
                useDiskCache: true,
              ),
              fit: BoxFit.fill,
              width: double.infinity,
              //height: 200.0,
              height: double.infinity,
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              height: 40.0,
              color: Colors.grey.withOpacity(0.5),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.comment,
                        color: Colors.amberAccent,
                      ),
                      Text(item.comments.toString(),style: TextStyle(color: Colors.white),)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        color: Colors.deepOrange,
                      ),
                      Text(item.favorites.toString(),style: TextStyle(color: Colors.white),)
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}