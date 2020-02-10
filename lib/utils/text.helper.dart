import 'dart:ui';

import 'package:flutter/material.dart';

class TextHelper {
  static final Color defaultTextColor = Colors.black;
  static final String defaultFont = "Lato";
  static final FontWeight defaultWeight = FontWeight.normal;
  static final double defaultFontSize = 14;

  static TextStyle customTextStyle(String fontName, Color textColor,
      FontWeight fontWeight, double fontSize) {
    String _fontName = (fontName == null) ? defaultFont : fontName;
    Color _textColor = (textColor == null) ? defaultTextColor : textColor;
    FontWeight _textFontWeight =
        (fontWeight == null) ? defaultWeight : fontWeight;
    double _textFontSize = (fontSize == null) ? defaultFontSize : fontSize;

    return TextStyle(
        fontFamily: _fontName,
        color: _textColor,
        fontWeight: _textFontWeight,
        fontSize: _textFontSize
    );
  }
}
