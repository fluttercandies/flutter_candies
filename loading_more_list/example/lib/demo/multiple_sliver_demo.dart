import 'package:example/common/item_builder.dart';
import 'package:example/common/tu_chong_repository.dart';
import 'package:example/common/tu_chong_source.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class MultipleSliverDemo extends StatefulWidget {
  @override
  _MultipleSliverDemoState createState() => _MultipleSliverDemoState();
}

class _MultipleSliverDemoState extends State<MultipleSliverDemo> {
  TuChongRepository listSourceRepository;
  TuChongRepository listSourceRepository1;

  @override
  void initState() {
    // TODO: implement initState
    listSourceRepository = new TuChongRepository();
    listSourceRepository1 = new TuChongRepository();
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository.dispose();
    listSourceRepository1.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: LoadingMoreCustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: Text("MultipleSliverDemo"),
          ),
          LoadingMoreSliverList(SliverListConfig<TuChongItem>(
            ItemBuilder.itemBuilder,
            listSourceRepository,
          )),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              child: Text("Next list"),
              color: Colors.blue,
              height: 100.0,
            ),
          ),
          SliverPersistentHeader(
            delegate: CommonExtentSliverPersistentHeaderDelegate(
                Container(
                  alignment: Alignment.center,
                  child: Text("Pinned Content"),
                  color: Colors.red,
                ),
                100.0),
            pinned: true,
          ),
          LoadingMoreSliverList(SliverListConfig<TuChongItem>(
            ItemBuilder.itemBuilder,
            listSourceRepository1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
//                    childAspectRatio: 0.5
            ),
          ))
        ],
      ),
    );
  }
}

class CommonExtentSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double extent;

  CommonExtentSliverPersistentHeaderDelegate(this.child, this.extent);

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(CommonExtentSliverPersistentHeaderDelegate oldDelegate) {
    //print("shouldRebuild---------------");
    return oldDelegate != this;
  }
}
