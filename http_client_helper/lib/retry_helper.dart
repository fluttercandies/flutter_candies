import 'cancellation_token.dart';

class RetryHelper {
  //try again，after millisecondsDelay time
  static Future<T> tryRun<T>(
    Future<T> Function() asyncFunc, {
    int millisecondsDelay = 100,
    int retries = 3,
    CancellationToken cancelToken,
    bool Function() throwThenExpction,
  }) async {
    int attempts = 0;
    while (attempts < retries) {
      attempts++;
      print("try at ${attempts} times");
      try {
        return await asyncFunc();
      } on OperationCanceledError catch (error) {
        throw error;
      } catch (error, stackTrace) {
        if (throwThenExpction != null && throwThenExpction()) {
          throw error;
        }
        //twice time to retry
        //if (attempts > 1) millisecondsDelay *= 2;
      }
      //delay to retry
      //try {
      if (attempts < retries) {
        var future = CancellationTokenSource.register(cancelToken,
            Future.delayed(Duration(milliseconds: millisecondsDelay)));
        await future;
      }

      //} on OperationCanceledError catch (error) {
      //throw error;
      //}
    }
  }
}
