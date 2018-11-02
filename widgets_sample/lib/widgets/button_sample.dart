import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("RaisedButton"),
              onPressed: () => {},
            ),
            RaisedButton(
              child: Text("DisabledRaisedButton"),
              onPressed: null,
            ),
            OutlineButton(
              child: Text("OutlineButton"),
              onPressed: () => {},
            ),
            FlatButton(
              child: Text("FlatButton"),
              onPressed: () => {},
            ),
            DropdownButton(
              value: dropdownValue,
              items: <String>['One', 'Two', 'Free', 'Four'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
            InkWell(
              child: Text("InkWell"),
              onTap: () {},
            ),
            RawMaterialButton(
              child: Text("RawMaterialButton"),
              onPressed: () {},
            ),
            ButtonBar(
              children: <Widget>[
                Text("ButtonBar"),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
            FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  // Perform some action
                }),
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return <String>['One', 'Two', 'Free', 'Four'].map((String item) {
                return new PopupMenuItem<String>(
                  value: item,
                  child: new Text(item),
                );
              }).toList();
            })
          ],
        ),
      ),
    );
  }
}
