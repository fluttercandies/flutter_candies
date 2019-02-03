import 'package:http/http.dart';

class HttpFactory {
  static Client _httpClient;

  static HttpFactory _instance;

  static HttpFactory getInstance() {
    if (_instance == null) {
      _instance = new HttpFactory._();
      _instance._init();
    }
    return _instance;
  }

  HttpFactory._();

  _init(){
    _httpClient = new Client();
  }

  Client getHttpClient() {
    return _httpClient;
  }
}

//测试是否是单例
void main() {
  print(HttpFactory.getInstance().getHttpClient()  == HttpFactory.getInstance().getHttpClient());
}
