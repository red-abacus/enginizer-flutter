
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'debouncer.dart';

class CustomDebouncerTextField extends StatelessWidget {
  final String labelText;
  final String currentValue;
  final Function listener;
  TextInputType textInputType = TextInputType.text;

  CustomDebouncerTextField(
      {this.labelText, this.listener, this.currentValue, this.textInputType});

  final _debouncer = Debouncer(milliseconds: 300);

  TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    _textController = TextEditingController(text: currentValue);
    _textController
      ..selection = TextSelection.collapsed(offset: currentValue != null ? currentValue.length : 0);

    return TextField(
      keyboardType: textInputType,
      autofocus: false,
      decoration:
          InputDecoration(labelText: labelText),
      style: TextHelper.customTextStyle(),
      onChanged: (value) {
        _debouncer.run(() => listener(value));
      },
      controller: _textController,
    );
  }
}
