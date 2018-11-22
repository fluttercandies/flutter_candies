import 'package:example/http_factory.dart';
import 'package:http/http.dart';
import 'package:loading_more_list/loading_more_base.dart';
import 'package:example/tu_chong_source.dart';
import 'dart:async';
import 'dart:convert';

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
  Future<bool> loadMore() async {
    if (isLoading || !hasMore) return true;
    // TODO: implement loadMore
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
      isLoading = true;

      //to show loading more clearly, in your app,ni
      await Future.delayed(Duration(milliseconds: 1500));

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
      print(exception);
    }

    //notice ui data change
    collectionChanged(this);

    isLoading = false;
    return isSuccess;
  }
}
