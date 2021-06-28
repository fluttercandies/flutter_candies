import 'package:flutter/material.dart';
import 'package:widgets_sample/widgets/base_sample.dart';

class TextSampleBody extends SampleBody {
  @override
  Widget getBody(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.red),
      child: Column(
        children: <Widget>[
          const Text(
            'Hello, How are you?Hello, How are you?Hello, How are you?Hello, How are you?Hello, How are you?Hello, How are you?',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text.rich(
            TextSpan(
              text: 'Hello', // default text style
              children: <TextSpan>[
                TextSpan(
                    text: ' beautiful ',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                    text: 'world',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Text(
            'hello flutter text',
            // ignore: deprecated_member_use
            style: Theme.of(context).textTheme.title,
          ),
        ],
      ),
    );
  }
}
