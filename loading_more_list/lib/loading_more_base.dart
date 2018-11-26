import 'dart:async';

import 'dart:collection';
import 'package:loading_more_list/indicator_widget.dart';
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

  IndicatorStatus indicatorStatus = IndicatorStatus.None;

  Future<bool> loadMore() async {
    if (isLoading || !hasMore) return true;
    // TODO: implement loadMore

    var preStatus = indicatorStatus;
    indicatorStatus = this.length == 0
        ? IndicatorStatus.FullScreenBusying
        : IndicatorStatus.LoadingMoreBusying;

    if (preStatus == IndicatorStatus.Error) {
      onStateChanged(this);
    }
    isLoading = true;
    var isSuccess = await loadData();
    isLoading = false;
    if (isSuccess) {
      if (this.length == 0) indicatorStatus = IndicatorStatus.Empty;
    } else {
      indicatorStatus = IndicatorStatus.Error;
    }
    onStateChanged(this);
    return isSuccess;
  }

  Future<bool> loadData() async {
    return true;
  }

  @override
  Future<bool> onRefresh() async {
    // TODO: implement OnRefresh
  }

  @override
  int get length => _array.length;
  set length(int newLength) => _array.length = newLength;

  @override
  void onStateChanged(LoadingMoreBase<T> source) {
    // TODO: implement notice
    super.onStateChanged(source);
  }
}

class _LoadingMoreBloc<T> {
  final _rebuild = new StreamController<LoadingMoreBase<T>>.broadcast();
  Stream<LoadingMoreBase<T>> get rebuild => _rebuild.stream;

  void onStateChanged(LoadingMoreBase<T> source) {
    if (!_rebuild?.isClosed) _rebuild.sink.add(source);
  }

  void dispose() {
    _rebuild?.close();
  }
}
