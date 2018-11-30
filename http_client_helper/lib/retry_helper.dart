import 'cancellation_token.dart';
import 'cancellation_token_source.dart';

class RetryHelper {
  //support try again
  static Future<T> tryRun<T>(
    Future<T> Function() asyncFunc, {
    int millisecondsDelay = 100,
    int retries = 3,
    CancellationToken cancelToken,
    bool Function() throwThenExpction,
  }) async {
    int attempts = 0;
    while (attempts <= retries) {
      attempts++;
      print("try_-${attempts}");
      try {
        return await asyncFunc();
      } on OperationCanceledError catch (error) {
        print("cancel-----------------------");
        throw error;
      } catch (error, stackTrace) {
        if (throwThenExpction != null && throwThenExpction()) {
          throw error;
        }
        //twice time to retry
        if (attempts > 1) millisecondsDelay *= 2;
      }

      //delay to retry
      var delay =
          Future.delayed(Duration(milliseconds: millisecondsDelay), () {});
      CancellationTokenSource.register(cancelToken, delay);
      await delay;
    }
  }
}
