import 'package:example/common/item_builder.dart';
import 'package:example/common/tu_chong_repository.dart';
import 'package:example/common/tu_chong_source.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/list_config.dart';
import 'package:loading_more_list/loading_more_sliver_list.dart';

class SliverGridDemo extends StatefulWidget {
  @override
  _SliverGridDemoState createState() => _SliverGridDemoState();
}

class _SliverGridDemoState extends State<SliverGridDemo> {
  TuChongRepository listSourceRepository;
  @override
  void initState() {
    // TODO: implement initState
    listSourceRepository = new TuChongRepository();
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LoadingMoreCustomScrollView(
        showGlowLeading: false,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: Text("SliverGridDemo"),
          ),
          LoadingMoreSliverList(SliverListConfig<TuChongItem>(
            ItemBuilder.itemBuilder, listSourceRepository,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
//                    childAspectRatio: 0.5
            ),
            //isLastOne: false
          ))
        ],
      ),
    );
  }
}
