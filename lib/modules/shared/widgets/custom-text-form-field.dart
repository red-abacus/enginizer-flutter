import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String currentValue;
  final Function listener;
  final bool enabled;
  final String errorText;

  CustomTextFormField(
      {this.labelText, this.listener, this.currentValue, this.enabled = true, this.errorText});

  TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    _textController = TextEditingController(text: currentValue);
    _textController
      ..selection = TextSelection.collapsed(offset: currentValue.length);

    return TextFormField(
        decoration: InputDecoration(labelText: labelText),
        onChanged: (value) {
          listener(value);
        },
        controller: _textController,
        enabled: enabled,
        validator: (value) {
          if (value.isEmpty) {
            return errorText;
          } else {
            return null;
          }
        });
  }
}
