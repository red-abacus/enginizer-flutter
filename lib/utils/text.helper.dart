import 'dart:ui';

import 'package:flutter/material.dart';

class TextHelper {
  static final Color defaultTextColor = Colors.black;
  static final String defaultFont = 'Lato';
  static final FontWeight defaultWeight = FontWeight.normal;
  static final double defaultFontSize = 14;

  static TextStyle customTextStyle(
      {String fontName, Color color, FontWeight weight, double size}) {
    String _fontName = (fontName == null) ? defaultFont : fontName;
    Color _textColor = (color == null) ? defaultTextColor : color;
    FontWeight _textFontWeight = (weight == null) ? defaultWeight : weight;
    double _textFontSize = (size == null) ? defaultFontSize : size;

    return TextStyle(
        fontFamily: _fontName,
        color: _textColor,
        fontWeight: _textFontWeight,
        fontSize: _textFontSize);
  }
}
