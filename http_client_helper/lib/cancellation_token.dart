import 'dart:async';
import 'package:http/http.dart';

//Cancellation token to cancel future in dart
class CancellationToken {
  /// list to store complter future
  var _completers = new List<Completer>();

  ///cancel error
  OperationCanceledError _cancelError;

  /// whether has canceled
  bool get isCanceled {
    return _cancelError != null;
  }

  /// if request have been canceled, save the cancel Error.
  OperationCanceledError get cancelError => _cancelError;

  /// cancel operation
  void cancel([String msg]) {
    _cancelError = new OperationCanceledError(msg ?? "cancel this token");
    if (!_completers.isEmpty) {
      _completers.forEach((e) => e.completeError(cancelError));
    }
  }

  /// add a [completer] to this token
  void _addCompleter(Completer completer) {
    if (isCanceled) {
      completer?.completeError(_cancelError);
      _completers.remove(completer);
    } else {
      if (!_completers.contains(completer)) {
        _completers.add(completer);
      }
    }
  }

  /// remove a [completer] from this token
  void _removeCompleter(Completer completer) {
    _completers.remove(completer);
  }

  //check whether it has canceled, yes ,throw
  void throwIfCancellationRequested() {
    if (isCanceled) {
      throw OperationCanceledError("this token has aleady canceled");
    }
  }
}

class OperationCanceledError extends Error {
  final String msg;
  OperationCanceledError(this.msg);
}

class CancellationTokenSource {
  static Future<T> register<T>(
      CancellationToken cancelToken, Future<T> future) {
    if (cancelToken != null && !cancelToken.isCanceled) {
      Completer completer = new Completer();
      cancelToken._addCompleter(completer);
      return Future.any([completer.future, future]).then<T>((result) {
        cancelToken._removeCompleter(completer);
        return result;
      }).catchError((error) {
        cancelToken._removeCompleter(completer);
        throw error;
      });
    } else {
      return future;
    }
  }
}
