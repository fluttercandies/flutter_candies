import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_client_helper/src/cancellation_token.dart';
import 'package:http_client_helper/src/retry_helper.dart';

class HttpClientHelper {
  static Client _httpClient = new Client();

  //http get with cancel, delay try again
  static Future<Response> get(url,
      {Map<String, String> headers,
      CancellationToken cancelToken,
      int retries = 3,
      Duration timeLimit,
      Duration timeRetry = const Duration(milliseconds: 100)}) async {
    cancelToken?.throwIfCancellationRequested();
    return await RetryHelper.tryRun<Response>(() {
      return CancellationTokenSource.register(
          cancelToken,
          timeLimit == null
              ? _httpClient.get(url, headers: headers)
              : _httpClient.get(url, headers: headers).timeout(timeLimit));
    }, cancelToken: cancelToken, timeRetry: timeRetry, retries: retries);
  }

  //http post with cancel, delay try again
  static Future<Response> post(url,
      {Map<String, String> headers,
      body,
      Encoding encoding,
      CancellationToken cancelToken,
      int retries = 3,
      Duration timeLimit,
      Duration timeRetry = const Duration(milliseconds: 100)}) async {
    cancelToken?.throwIfCancellationRequested();
//    if (body is Map) {
//      body = utf8.encode(json.encode(body));
//      headers['content-type'] = 'application/json';
//    }
    return await RetryHelper.tryRun<Response>(() {
      return CancellationTokenSource.register(
          cancelToken,
          timeLimit == null
              ? _httpClient.post(url,
                  headers: headers, body: body, encoding: encoding)
              : _httpClient
                  .post(url, headers: headers, body: body, encoding: encoding)
                  .timeout(timeLimit));
    }, cancelToken: cancelToken, timeRetry: timeRetry, retries: retries);
  }
}
