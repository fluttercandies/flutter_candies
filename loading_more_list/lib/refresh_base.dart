import 'dart:async';

abstract class RefreshBase
{
  Future<bool> onRefresh();
}