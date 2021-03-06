import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertInfoWidget extends StatelessWidget {
  String contentString;

  AlertInfoWidget(this.contentString);

  @override
  ListTile build(BuildContext context) {
    return ListTile(
      title: new Container(
        height: 70,
        decoration: BoxDecoration(
          color: red,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            bottomLeft: Radius.circular(35),
            topRight: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.info,
              color: Theme.of(context).cardColor,
              size: 60,
            ),
            new Expanded(
              child: new Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: new Text(
                  contentString,
                  style: new TextStyle(
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
