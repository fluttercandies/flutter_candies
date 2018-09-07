import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
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
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
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
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
        ),
        body:
//      new Center(
//        child: new Container(
//          margin: const EdgeInsets.all(10.0),
//          color: const Color(0xFF00FF00),
//          width: 48.0,
//          height: 48.0,
//        ),
//      ),
        //image with border
            new Container(
          constraints: new BoxConstraints.expand(
            height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 200.0,
          ),
          padding: const EdgeInsets.all(8.0),
          color: Colors.teal.shade700,
          alignment: Alignment.center,
          child: new Text('Hello World',
              style: Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(color: Colors.red)),

          foregroundDecoration: new BoxDecoration(
            image: new DecorationImage(
              image:
                  new NetworkImage('https://z1.dfcfw.com/2018/9/7/20180907110108337218924.jpg'),
              centerSlice: new Rect.fromLTRB(270.0, 180.0, 500.0, 530.0),
            ),
          ),
          transform: new Matrix4.rotationZ(0.1),
        )
//        new Container(
//          decoration: new BoxDecoration(
//            color: const Color(0xff7c94b6),
//            image: new DecorationImage(
//              image: new NetworkImage('https://z1.dfcfw.com/2018/9/7/20180907110108337218924.jpg'),
//              fit: BoxFit.fitWidth,
//            ),
//            border: new Border.all(
//              color: Colors.black,
//              width: 8.0,
//            ),
//          ),
//        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
