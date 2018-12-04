# http_client_helper

[![pub package](https://img.shields.io/pub/v/http_client_helper.svg)](https://pub.dartlang.org/packages/http_client_helper)

A Flutter plugin for http request with cancel and retry fuctions.

## Usage

To use this plugin, add `http_client_helper` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart
  cancellationToken = new CancellationToken();
    try {
      await HttpClientHelper.get(url,
              cancelToken: cancellationToken,
              millisecondsDelay: 1000,
              retries: 10)
          .then((response) {
        setState(() {
          msg = response.body;
        });
      });
    } on OperationCanceledError catch (e) {
      setState(() {
        msg = "cancel";
      });
    } catch (e) {

    }
```

If you need other method of http, you can do it with RetryHelper and CancellationToken as you wish.
as follow
``` dart
static Future<Response> get(url,
      {Map<String, String> headers,
      CancellationToken cancelToken,
      int millisecondsDelay = 100,
      int retries = 3}) async {
    cancelToken?.throwIfCancellationRequested();
    return await RetryHelper.tryRun<Response>(() {
      return CancellationTokenSource.register(
          cancelToken, _httpClient.get(url, headers: headers));
    },
        cancelToken: cancelToken,
        millisecondsDelay: millisecondsDelay,
        retries: retries);
  }
``` 

Please see the example app of this plugin for a full example.