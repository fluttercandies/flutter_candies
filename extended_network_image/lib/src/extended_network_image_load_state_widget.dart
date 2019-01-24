import 'package:extended_network_image/src/extended_network_image.dart';
import 'package:extended_network_image/src/extended_network_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ExtendedNetworkImageLoadStateWidget extends StatelessWidget {
  //load state
  final LoadState loadState;

  /// The image to display.
  final ExtendedNetworkImageProvider image;

  ExtendedNetworkImageLoadStateWidget({@required this.loadState, this.image});

  @override
  Widget build(BuildContext context) {
    switch (loadState) {
      case LoadState.loading:
        break;
      case LoadState.completed:
        break;
      case LoadState.failed:
        break;
    }
    return Container();
  }
}
