import 'package:flutter/material.dart';
import 'package:widgets_sample/widgets/container_sample.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Widgets Sample',
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
      home: new MyHomePage(title: 'Flutter Widgets Sample Home Page'),
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
  List<WidgetNames> widgetNames;
  @override
  void initState() {
    widgetNames = WidgetNames.values;
    // widgetNames=WidgetNames.values;
//    widgetNames = new List<String>();
//    widgetNames.add("Container");
//    widgetNames.add("Row");
//    widgetNames.add("Column");
    // TODO: implement initState
    super.initState();
  }

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
      body: new Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => InkWell(
            onTap: () {
              goWigetPage(widgetNames[index]);
            },
            child: Container(
                margin: EdgeInsets.all(8.0),
                color: Colors.blue,
                child: Center(
                  child: Text(widgetNames[index]
                      .toString()
                      .replaceAll("WidgetNames.", "")),
                ))),
        itemCount: widgetNames.length,
        itemExtent: 100.0,
      )),
    );
  }

  void goWigetPage(WidgetNames widgetName) {
    Widget page;
    String title=widgetName.toString().replaceAll("WidgetNames.", "");
    switch (widgetName) {
      case WidgetNames.Container:
        page = new ContainerSample(title);
        break;
      case WidgetNames.Row:
        page = new ContainerSample(title);
        break;
      case WidgetNames.Column:
        page = new ContainerSample(title);
        break;
      case WidgetNames.Image:
        page = new ContainerSample(title);
        break;
    }

    Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
      return page;
    },
//        transitionsBuilder: (
//      BuildContext context,
//      Animation<double> animation,
//      Animation<double> secondaryAnimation,
//      Widget child,
//    ) {
//      return createTransition(animation, child);
//    }
    )
    );
  }

  SlideTransition createTransition(Animation<double> animation, Widget child) {
    return new SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(animation),
      child: child, // child is the value returned by pageBuilder
    );
  }
}

enum WidgetNames {
  Container,
  Row,
  Column,
  Image
}
