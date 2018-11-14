# extended_nested_scroll_view

extended nested scroll view to fix following issues.

1.[pinned sliver header issue](https://github.com/flutter/flutter/issues/22393)

2.[inner scrollables in tabview sync issue](https://github.com/flutter/flutter/issues/21868)

3.pull to refresh is not work.

[Chinese bolg]()

### Add dependency

```yaml
dependencies:
  extended_nested_scroll_view: x.x.x  #latest version
```


# Example for issue 1

give total height of pinned sliver headers in pinnedHeaderSliverHeightBuilder callback
``` dart
 var tabBarHeight = primaryTabBar.preferredSize.height;
    var pinnedHeaderHeight =
        //statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight +
            //pinned tabbar height in header
            (primaryTC.index == 0 ? tabBarHeight * 2 : tabBarHeight);
            

 return extended.NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return pinnedHeaderHeight;
        },
       
```
# Example for issue 2

### Step1.

Put your list which in tabview into NestedScrollViewInnerScrollPositionKeyWidget,and get unique a key
``` dart
 return extended.NestedScrollViewInnerScrollPositionKeyWidget(
        widget.tabKey,
        // myRefresh.RefreshIndicator(
        // child:
        ListView.builder(
            itemBuilder: (c, i) {
              return Container(
                //decoration: BoxDecoration(border: Border.all(color: Colors.orange,width: 1.0)),
                alignment: Alignment.center,
                height: 60.0,
                child: Text(widget.tabKey.toString() + ": List$i"),
              );
            },
            itemCount: 100)
        //,
        //onRefresh: onRefresh,
        // )
        );
```
### Step 2

get current tab key in innerScrollPositionKeyBuilder callback. this key should as same as in step 1 given.
``` dart
 extended.NestedScrollView(
        innerScrollPositionKeyBuilder: () {
          var index = "Tab";
          if (primaryTC.index == 0) {
            index +=
                (primaryTC.index.toString() + secondaryTC.index.toString());
          } else {
            index += primaryTC.index.toString();
          }
          return Key(index);
        },
```
# Example for NestedScrollView pull to refresh

NestedScrollViewRefreshIndicator is as the same as Flutter RefreshIndicator.
``` dart
 NestedScrollViewRefreshIndicator(
       onRefresh: onRefresh,
       child: extended.NestedScrollView(
         headerSliverBuilder: (c, f) {
           return _buildSliverHeader(primaryTabBar);
         },
```
Please see the example app of this for a full example.