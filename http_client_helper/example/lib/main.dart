import 'package:flutter/material.dart';
import 'package:http_client_helper/http_client_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'http client helper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CancellationToken cancellationToken;
  String msg = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void request() async {
    var url = "https://api.tuchong.com/feed-app";
    //url = "https://google.com";
    setState(() {
      msg = "begin request";
    });
    cancellationToken = new CancellationToken();
    try {
      await HttpClientHelper.get(url,
              cancelToken: cancellationToken,
              timeRetry: Duration(milliseconds: 1000),
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
    } catch (e) {}
  }

  void cancel() {
    cancellationToken?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      request();
                    },
                    child: Text("Requset")),
                FlatButton(
                    onPressed: () {
                      cancel();
                    },
                    child: Text("Cancel"))
              ],
            ),
            Expanded(
              child: Text(msg),
            )
          ],
        ));
  }
}
