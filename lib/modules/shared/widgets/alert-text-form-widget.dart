import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom-show-dialog.widget.dart';

class AlertTextFormWidget extends StatelessWidget {
  String title;
  String placeholder;
  String buttonName;
  Function addTextFunction;
  String _value = "";

  AlertTextFormWidget(
      {this.title, this.placeholder, this.buttonName, this.addTextFunction});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        width: 260.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                    ),
                    child: new Text(
                      this.title,
                      style: TextHelper.customTextStyle(
                          color: Colors.black, weight: FontWeight.bold, size: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

// dialog centre
            new Expanded(
              child: new Container(
                  child: new TextField(
                    onChanged: (val) {
                      _value = val;
                    },
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: new EdgeInsets.all(10),
                    hintText: this.placeholder,
                    hintStyle: TextHelper.customTextStyle(
                        color: gray, size: 12)),
              )),
              flex: 2,
            ),

            new Expanded(
              child: new Container(
                padding: new EdgeInsets.all(16.0),
                decoration: new BoxDecoration(
                  color: red,
                ),
                child: FlatButton(
                  child: new Text(
                    this.buttonName,
                    style: TextHelper.customTextStyle(
                        color: Colors.white, weight: FontWeight.bold, size: 18.0),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    addTextFunction(_value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
