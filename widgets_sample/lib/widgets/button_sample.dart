import 'package:flutter/material.dart';
import 'package:widgets_sample/widgets/base_sample.dart';

class ButtonSampleBody extends SampleBody {
  String dropdownValue = 'Free';

  @override
  Widget getBody(BuildContext context) {
    return SingleChildScrollView(
      child: ButtonTheme(
        textTheme: ButtonTextTheme.normal,
        minWidth: 88.0,
        height: 36.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text('RaisedButton'),
              onPressed: () {},
            ),
            const RaisedButton(
              child: Text('DisabledRaisedButton'),
              onPressed: null,
            ),
            OutlineButton(
              child: const Text('OutlineButton'),
              onPressed: () {},
            ),
            FlatButton(
              child: const Text('FlatButton'),
              onPressed: () {},
            ),
            DropdownButton<String>(
              value: dropdownValue,
              items: <String>['One', 'Two', 'Free', 'Four'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String value) {
                setState(() {
                  dropdownValue = value;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
            InkWell(
              child: const Text('InkWell'),
              onTap: () {},
            ),
            RawMaterialButton(
              child: const Text('RawMaterialButton'),
              onPressed: () {},
            ),
            ButtonBar(
              children: <Widget>[
                const Text('ButtonBar'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  // Perform some action
                }),
            PopupMenuButton<String>(itemBuilder: (BuildContext context) {
              return <String>['One', 'Two', 'Free', 'Four'].map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            })
          ],
        ),
      ),
    );
  }
}
