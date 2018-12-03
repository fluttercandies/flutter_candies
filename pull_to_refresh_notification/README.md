# pull_to_refresh_notification

[![pub package](https://img.shields.io/pub/v/pull_to_refresh_notification.svg)](https://pub.dartlang.org/packages/pull_to_refresh_notification)

widget to build  pull to refresh effects.

[Chinese bolg](https://juejin.im/post/5bebcc44f265da61682aedb8)

# Sample 1 appbar
build appbar to pull to refresh with PullToRefreshContainer

![](https://github.com/zmtzawqlp/Flutter/blob/master/gif/PullToRefreshAppbar.gif)
```dart
   Widget build(BuildContext context) {
 return PullToRefreshNotification(
      color: Colors.blue,
      pullBackOnRefresh: true,
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: <Widget>[
          PullToRefreshContainer(buildPulltoRefreshAppbar),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "List item : ${listlength - index}",
                      style: TextStyle(fontSize: 15.0, inherit: false),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 2.0,
                    )
                  ],
                ));
          }, childCount: listlength)),
        ],
      ),
    );
}
    
     Widget buildPulltoRefreshAppbar(PullToRefreshScrollNotificationInfo info) {
        print(info?.mode);
        print(info?.dragOffset);
    //    print("------------");
        var action = Padding(
          child: info?.refreshWiget ?? Icon(Icons.more_horiz),
          padding: EdgeInsets.all(15.0),
        );
        var offset = info?.dragOffset ?? 0.0;
    //    var mode = info?.mode;
    //    if (mode != null && mode == RefreshIndicatorMode.done) {
    //      //showToast("Refresh done");
    //    }
        return SliverAppBar(
            pinned: true,
            title: Text("PullToRefreshAppbar"),
            centerTitle: true,
            expandedHeight: 200.0 + offset,
            actions: <Widget>[action],
            flexibleSpace: FlexibleSpaceBar(
                //centerTitle: true,
                title: Text(
                  info?.mode?.toString() ?? "",
                  style: TextStyle(fontSize: 10.0),
                ),
                collapseMode: CollapseMode.pin,
                background: Image.asset(
                  "assets/467141054.jpg",
                  //fit: offset > 0.0 ? BoxFit.cover : BoxFit.fill,
                  fit: BoxFit.cover,
                )));
      }
```

# Sample 2 header
build header to pull to refresh with PullToRefreshContainer.
and you can easy to handle the status in pulling.

![](https://github.com/zmtzawqlp/Flutter/blob/master/gif/PullToRefreshHeader.gif)
```dart
  Widget build(BuildContext context) {
    return PullToRefreshNotification(
       color: Colors.blue,
       onRefresh: onRefresh,
       maxDragOffset: 80.0,
       child: CustomScrollView(
         slivers: <Widget>[
           SliverAppBar(
             pinned: true,
             title: Text("PullToRefreshHeader"),
           ),
           PullToRefreshContainer(buildPulltoRefreshHeader),
           SliverList(
               delegate:
                   SliverChildBuilderDelegate((BuildContext context, int index) {
             return Container(
                 padding: EdgeInsets.only(bottom: 4.0),
                 child: Column(
                   children: <Widget>[
                     Text(
                       "List item : ${listlength - index}",
                       style: TextStyle(fontSize: 15.0, inherit: false),
                     ),
                     Divider(
                       color: Colors.grey,
                       height: 2.0,
                     )
                   ],
                 ));
           }, childCount: listlength)),
         ],
       ),
     );
   }
 
   Widget buildPulltoRefreshHeader(PullToRefreshScrollNotificationInfo info) {
     //print(info?.mode);
     //print(info?.dragOffset);
 //    print("------------");
     var offset = info?.dragOffset ?? 0.0;
     var mode = info?.mode;
     Widget refreshWiget = Container();
     //it should more than 18, so that RefreshProgressIndicator can be shown fully
     if (info?.refreshWiget != null &&
         offset > 18.0 &&
         mode != RefreshIndicatorMode.error) {
       refreshWiget = info.refreshWiget;
     }
 
     Widget child = null;
     if (mode == RefreshIndicatorMode.error) {
       child = GestureDetector(
           onTap: () {
             // refreshNotification;
             info?.pullToRefreshNotificationState?.show();
           },
           child: Container(
             color: Colors.grey,
             alignment: Alignment.bottomCenter,
             height: offset,
             width: double.infinity,
             //padding: EdgeInsets.only(top: offset),
             child: Container(
               padding: EdgeInsets.only(left: 5.0),
               alignment: Alignment.center,
               child: Text(
                 mode?.toString() + "  click to retry" ?? "",
                 style: TextStyle(fontSize: 12.0, inherit: false),
               ),
             ),
           ));
     } else {
       child = Container(
         color: Colors.grey,
         alignment: Alignment.bottomCenter,
         height: offset,
         width: double.infinity,
         //padding: EdgeInsets.only(top: offset),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             refreshWiget,
             Container(
               padding: EdgeInsets.only(left: 5.0),
               alignment: Alignment.center,
               child: Text(
                 mode?.toString() ?? "",
                 style: TextStyle(fontSize: 12.0, inherit: false),
               ),
             )
           ],
         ),
       );
     }
 
     return SliverToBoxAdapter(
       child: child,
     );
   }
 
   bool success = false;
   Future<bool> onRefresh() {
     final Completer<bool> completer = new Completer<bool>();
     new Timer(const Duration(seconds: 2), () {
       completer.complete(success);
       success = true;
     });
     return completer.future.then((bool success) {
       if (success) {
         setState(() {
           listlength += 10;
         });
       }
       return success;
     });
   }
```
# Sample 3 image
build zoom image to pull to refresh with using PullToRefreshContainer.

![](https://github.com/zmtzawqlp/Flutter/blob/master/gif/PullToRefreshImage.gif)
```dart
 Widget build(BuildContext context) {
     // TODO: implement build
     return PullToRefreshNotification(
       color: Colors.blue,
       pullBackOnRefresh: true,
       onRefresh: onRefresh,
       child: CustomScrollView(
         slivers: <Widget>[
           SliverAppBar(
             title: Text("PullToRefreshImage"),
           ),
           PullToRefreshContainer(buildPulltoRefreshImage),
           SliverList(
               delegate:
                   SliverChildBuilderDelegate((BuildContext context, int index) {
             return Container(
                 padding: EdgeInsets.only(bottom: 4.0),
                 child: Column(
                   children: <Widget>[
                     Text(
                       "List item : ${listlength - index}",
                       style: TextStyle(fontSize: 15.0, inherit: false),
                     ),
                     Divider(
                       color: Colors.grey,
                       height: 2.0,
                     )
                   ],
                 ));
           }, childCount: listlength)),
         ],
       ),
     );
   }
   
   Widget buildPulltoRefreshImage(PullToRefreshScrollNotificationInfo info) {
     print(info?.mode);
     print(info?.dragOffset);
 //    print("------------");
     var offset = info?.dragOffset ?? 0.0;
     Widget refreshWiget = Container();
     if (info?.refreshWiget != null) {
       refreshWiget = Material(
         type: MaterialType.circle,
         color: Theme.of(context).canvasColor,
         elevation: 2.0,
         child: Padding(
           padding: EdgeInsets.all(12),
           child: info.refreshWiget,
         ),
       );
     }
 
     return SliverToBoxAdapter(
       child: Stack(
         alignment: Alignment.center,
         children: <Widget>[
           Container(
               height: 200.0 + offset,
               width: double.infinity,
               child: Image.asset(
                 "assets/467141054.jpg",
                 //fit: offset > 0.0 ? BoxFit.cover : BoxFit.fill,
                 fit: BoxFit.cover,
               )),
           Center(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 refreshWiget,
                 Container(
                   padding: EdgeInsets.only(left: 5.0),
                   alignment: Alignment.center,
                   child: Text(
                     info?.mode?.toString() ?? "",
                     style: TextStyle(fontSize: 12.0, inherit: false),
                   ),
                 )
               ],
             ),
           )
         ],
       ),
     );
   }
```

Please see the example app of this for a full example.