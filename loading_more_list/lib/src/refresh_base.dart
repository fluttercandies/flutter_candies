import 'dart:async';

abstract class RefreshBase {
  //if clear is true, it will clear list,before request
  Future<bool> refresh([bool clearBeforeRequest = false]);
  Future<bool> errorRefresh();
}
