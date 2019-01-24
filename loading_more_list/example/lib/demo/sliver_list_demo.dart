import 'package:example/common/item_builder.dart';
import 'package:example/common/tu_chong_repository.dart';
import 'package:example/common/tu_chong_source.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class SliverListDemo extends StatefulWidget {
  @override
  _SliverListDemoState createState() => _SliverListDemoState();
}

class _SliverListDemoState extends State<SliverListDemo> {
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
            title: Text("SliverListDemo"),
          ),
          LoadingMoreSliverList(SliverListConfig<TuChongItem>(
            itemBuilder: ItemBuilder.itemBuilder,
            sourceList: listSourceRepository,
            //isLastOne: false
          ))
        ],
      ),
    );
  }
}
