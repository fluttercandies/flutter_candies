import 'package:example/common/http_factory.dart';
import 'package:http/http.dart';
import 'package:loading_more_list/indicator_widget.dart';
import 'package:loading_more_list/loading_more_base.dart';
import 'package:example/common/tu_chong_source.dart';
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
