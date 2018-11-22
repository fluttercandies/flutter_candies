import 'dart:async';

import 'dart:collection';
import 'package:loading_more_list/refresh_base.dart';

class LoadingMoreBase<T> extends ListBase<T>
    with _LoadingMoreBloc<T>, RefreshBase {
  var _array = <T>[];

  @override
  T operator [](int index) {
    // TODO: implement []
    return _array[index];
  }

  @override
  void operator []=(int index, T value) {
    // TODO: implement []=
    _array[index] = value;
  }

  bool get hasMore => true;
  bool isLoading = false;

  @override
  Future<bool> loadMore() async {}

  @override
  Future<bool> onRefresh() async {
    // TODO: implement OnRefresh
  }

  @override
  int get length => _array.length;
  set length(int newLength) => _array.length = newLength;

  @override
  void collectionChanged(LoadingMoreBase<T> source) {
    // TODO: implement notice
    super.collectionChanged(source);
  }
}

class _LoadingMoreBloc<T> {
  final _rebuild = new StreamController<LoadingMoreBase<T>>.broadcast();
  Stream<LoadingMoreBase<T>> get rebuild => _rebuild.stream;

  void collectionChanged(LoadingMoreBase<T> source) {
    _rebuild.sink.add(source);
  }

  void dispose() {
    _rebuild?.close();
  }
}
