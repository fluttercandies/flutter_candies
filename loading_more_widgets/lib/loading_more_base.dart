import 'dart:async';

import 'dart:collection';

abstract class LoadingMoreBase<T> {
  List<T> list;
  final _onRebuild = new StreamController<LoadingMoreBase<T>>.broadcast();
  Stream<LoadingMoreBase<T>> get onRebuild => _onRebuild.stream;

  bool hasMore;

  //
  bool loadMore();
}
