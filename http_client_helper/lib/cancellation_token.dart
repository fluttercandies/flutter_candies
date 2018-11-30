import 'dart:async';
import 'package:http/http.dart';

class CancellationToken {
//  /// Whether is throw by [cancel]
//  static bool isCancel(DioError e) {
//    return e.type == DioErrorType.CANCEL;
//  }

  bool get isCanceled {
    return _cancelError != null;
  }

  /// If request have been canceled, save the cancel Error.
  OperationCanceledError get cancelError => _cancelError;

  /// Cancel the request
  void cancel([String msg]) {
    _cancelError = new OperationCanceledError(msg ?? "user cancel");
    if (!completers.isEmpty) {
      completers.forEach((e) => e.completeError(cancelError));
    }
  }

  _trigger(completer) {
    if (completer != null) {
      completer.completeError(cancelError);
      completers.remove(completer);
    }
  }

  /// Add a [completer] to the token.
  /// [completer] is used to cancel the request before it's not completed.
  ///
  /// Note: you shouldn't invoke this method by yourself. It's just used inner [Dio].
  /// @nodoc
  void addCompleter(Completer completer) {
    if (cancelError != null) {
      _trigger(completer);
    } else {
      if (!completers.contains(completer)) {
        completers.add(completer);
      }
    }
  }

  /// Remove a [completer] from the token.
  ///
  /// Note: you shouldn't invoke this method by yourself. It's just used inner [Dio].
  /// @nodoc
  void removeCompleter(Completer completer) {
    completers.remove(completer);
  }

  var completers = new List<Completer>();
  OperationCanceledError _cancelError;

  void throwIfCancellationRequested() {
    if (isCanceled) {
      throw OperationCanceledError("aleady canceled");
      //throw _cancelError;
    }
  }
}

class OperationCanceledError extends Error {
  final String msg;
  OperationCanceledError(this.msg);
}
