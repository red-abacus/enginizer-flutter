import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String currentValue;
  final Function listener;
  final bool enabled;
  final String errorText;
  bool validate = true;
  TextInputType textInputType = TextInputType.text;

  CustomTextFormField(
      {this.labelText,
      this.listener,
      this.currentValue,
      this.enabled = true,
      this.errorText,
      this.validate,
      this.textInputType});

  TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    _textController = TextEditingController(text: currentValue);
    _textController
      ..selection = TextSelection.collapsed(offset: currentValue.length);

    return TextFormField(
      keyboardType: textInputType,
        decoration: InputDecoration(labelText: labelText),
        onChanged: (value) {
          listener(value);
        },
        controller: _textController,
        enabled: enabled,
        validator: (value) {
          if (validate) {
            if (value.isEmpty) {
              return errorText;
            }
          }

          return null;
        });
  }
}
