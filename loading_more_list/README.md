# loading_more_list

easily build loading more list

# how to use it
## 1. prepare for loading more collection
First, you need to extend [LoadingMoreBase](https://github.com/zmtzawqlp/Flutter_Candies/blob/master/loading_more_list/lib/loading_more_base.dart) and 
override getData method to get your list item. 
if you want to override onLoad method,
please take care of staus in this method.

```dart
class TuChongRepository extends LoadingMoreBase<TuChongItem> {
  int pageindex = 1;

  @override
  // TODO: implement hasMore
  bool _hasMore = true;
  bool get hasMore => _hasMore && length < 20;

  @override
  Future<bool> onRefresh() async {
    // TODO: implement onRefresh
    pageindex = 1;
    return loadMore();
  }

  @override
  Future<bool> getData() async {
    // TODO: implement getData
    String url = "";
    if (this.length == 0) {
      url = "https://api.tuchong.com/feed-app";
    } else {
      int lastPostId = this[this.length - 1].post_id;
      url =
          "https://api.tuchong.com/feed-app?post_id=${lastPostId}&page=${pageindex}&type=loadmore";
    }
    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      await Future.delayed(Duration(milliseconds: 500, seconds: 1));

      var result = await HttpFactory.getInstance().getHttpClient().get(url);

      var source = TuChongSource.fromJson(json.decode(result.body));
      if (pageindex == 1) {
        this.clear();
      }

      source.feedList.forEach((item) {
        if (item.hasImage && !this.contains(item) && hasMore) {
          this.add(item);
        }
      });

      _hasMore = source.feedList.length != 0;
      pageindex++;
      isSuccess = true;
    } catch (exception) {
      isSuccess = false;
      print(exception);
    }
    return isSuccess;
  }
}

```

## 2.loading more for ListView/GridView
![](https://github.com/zmtzawqlp/Flutter_Candies/blob/master/gif/LoadingMoreListView.gif)
ListConfig for ListView/Grid
```dart
 final Widget Function(BuildContext context, T item, int index) itemBuilder;
```
itemBuilder is used to get how a item like.

```dart
  //source list
  final LoadingMoreBase<T> sourceList;
```
sourceList is the source of list.
```dart
class ListConfig<T> extends LoadingMoreListConfig<T> {
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final double itemExtent;
  final int itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double cacheExtent;
  final int semanticChildCount;

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

  ListConfig(
    @required itemBuilder,
    @required sourceList, {
    this.showGlowLeading: true,
    this.showGlowTrailing: true,
    LoadingMoreIndicatorBuilder indicatorBuilder,
    SliverGridDelegate gridDelegate,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.itemCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
  }) : super(itemBuilder, sourceList,
            indicatorBuilder: indicatorBuilder, gridDelegate: gridDelegate);
}
```
### create loading more ListView with following code:
```dart
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
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("ListViewDemo"),
          ),
          Expanded(
            child: LoadingMoreList(
                ListConfig<TuChongItem>(
                    ItemBuilder.itemBuilder, listSourceRepository,
//                    showGlowLeading: false,
//                    showGlowTrailing: false,
                    padding: EdgeInsets.all(0.0)),),
          )
        ],
      ),
    );
  }
```
and it also support to loading error
![](https://github.com/zmtzawqlp/Flutter_Candies/blob/master/gif/LoadingMoreError.gif)


## 3.loading more for Sliver or MultipleSlivers
![](https://github.com/zmtzawqlp/Flutter_Candies/blob/master/gif/LoadingMoreMultipleSliver.gif)
SliverListConfig for SliverList/SliverGrid

```dart
//config for SliverList and SliverGrid
class SliverListConfig<T> extends LoadingMoreListConfig<T> {
  //whether show no more  .
  bool showNoMore = true;
  //whether show fullscreenLoading for multiple sliver
  bool showFullScreenLoading = true;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  final int childCount;

  SliverListConfig(
    @required itemBuilder,
    @required sourceList, {
    LoadingMoreIndicatorBuilder indicatorBuilder,
    SliverGridDelegate gridDelegate,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.childCount,
  }) : super(itemBuilder, sourceList,
            indicatorBuilder: indicatorBuilder, gridDelegate: gridDelegate);
}
```
### create loading more SliverList with following code:
put Slivers into LoadingMoreCustomScrollView
```dart
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
         slivers: <Widget>[
           SliverAppBar(
             pinned: true,
             title: Text("SliverListDemo"),
           ),
           LoadingMoreSliverList(
               SliverListConfig<TuChongItem>(
                 ItemBuilder.itemBuilder, listSourceRepository,
                 //isLastOne: false
               ))
         ],
       ),
     );
   }
```
### create loading more MultipleSlivers with following code:
and you can also use multiple sliver list.
```dart
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
    listSourceRepository?.dispose();
    listSourceRepository1?.dispose();
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
            delegate: CommonSliverPersistentHeaderDelegate(
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
```
## 4.loading more for CustomIndicator
![](https://github.com/zmtzawqlp/Flutter_Candies/blob/master/gif/LoadingMoreCustomIndicator.gif)
provide indicatorBuilder and you can define your indicator base on loading status
```dart
 @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("CustomIndicatorDemo"),
          ),
          Expanded(
            child: LoadingMoreList(
              ListConfig<TuChongItem>(
                  ItemBuilder.itemBuilder, listSourceRepository,
                  indicatorBuilder: _buildIndicator,
                  padding: EdgeInsets.all(0.0),
              ),
            ),
          )
        ],
      ),
    );
  }

  //you can use IndicatorWidget or build yourself widget
  //in this demo, we define custom for all status.
  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    Widget widget;
    bool full = (status == IndicatorStatus.FullScreenBusying);
    double height = 35.0;
    switch (status) {
      case IndicatorStatus.None:
        widget = Container(height: 0.0);
        height = 0.0;
        break;
      case IndicatorStatus.LoadingMoreBusying:
      case IndicatorStatus.FullScreenBusying:
        double indicatorSize = full ? 30.0 : 15.0;
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15.0),
                height: indicatorSize,
                width: indicatorSize,
                child: getIndicator(context)),
            (!full
                ? Text(
                    "正在加载...慌什么慌",
                  )
                : Text("正在加载...慌什么慌",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 28.0))),
          ],
        );
        break;
      case IndicatorStatus.Error:
        widget = Text(
          "加载失败，搞个川川",
        );
        break;
      case IndicatorStatus.NoMoreLoad:
        widget = Text("没有了，不要拖了");
        break;
      case IndicatorStatus.Empty:
        widget = EmptyWidget(
          "这里只有空",
        );
        break;
    }

    widget = Container(
        width: double.infinity,
        height: full ? double.infinity : height,
        child: widget,
        color: Colors.grey[200],
        alignment: Alignment.center);

//    if (isSliver) {
//      if (status == IndicatorStatus.FullScreenBusying) {
//        widget = SliverFillRemaining(
//          child: widget,
//        );
//      } else if (status == IndicatorStatus.Empty) {
//        widget = SliverToBoxAdapter(
//          child: widget,
//        );
//      }
//    }
    if (status == IndicatorStatus.Error) {
      widget = GestureDetector(
        onTap: () {
          listSourceRepository.loadMore();
        },
        child: widget,
      );
    }
    return widget;
  }
```

Please see the example app of this for a full example.