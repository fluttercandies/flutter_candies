import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:widgets_sample/widgets/base_sample.dart';

class TextSampleBody extends SampleBody {
  @override
  Widget getBody(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.red),
      child: new Column(
        children: <Widget>[
          new Text(
            'Hello, How are you?Hello, How are you?Hello, How are you?Hello, How are you?Hello, How are you?Hello, How are you?',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          Text.rich(
            const TextSpan(

              text: 'Hello', // default text style
              children: const <TextSpan>[
                const TextSpan(
                    text: ' beautiful ',
                    style: const TextStyle(fontStyle: FontStyle.italic)),
                const TextSpan(
                    text: 'world',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          )
          ,
          Text("hello flutter text",style: Theme.of(context).textTheme.title,),
        ],
      ),
    );
  }
}
