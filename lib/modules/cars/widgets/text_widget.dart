import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {

  String text;
  TextAlign textAlign;
  int maxLines;
  double fontSize;
  Color color;
  FontWeight fontWeight;
  String font;

  TextWidget(this.text,
      { this.textAlign = TextAlign.start,
        this.maxLines = 1,
        this.fontSize = 15.0,
        this.color = Colors.black,
        this.fontWeight = FontWeight.normal,
        this.font = 'Lato'});

  @override
  Widget build(BuildContext context) {
    return Text(text == null ? "" : text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          fontSize: fontSize,
          fontFamily: font,
          color: color,
          fontWeight: fontWeight,
        ));
  }
}
