import 'dart:async';

import 'cancellation_token.dart';


class CancellationTokenSource {
  static Future<T> register<T>(
      CancellationToken cancelToken, Future<T> future) {
    if (cancelToken != null && !cancelToken.isCanceled) {
      Completer completer = new Completer();
      cancelToken.addCompleter(completer);
      return Future.any([completer.future, future]).then<T>((result) {
        cancelToken.removeCompleter(completer);
        return result;
      }).catchError((e) {
        cancelToken.removeCompleter(completer);
        throw e;
      });
    } else {
      return future;
    }
  }
}
