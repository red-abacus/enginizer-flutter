import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String currentValue;
  final Function listener;
  final bool enabled;
  final String errorText;
  bool validate;
  bool obscureText;
  TextInputType textInputType;
  int charactersCondition;

  CustomTextFormField(
      {this.labelText,
      this.listener,
      this.currentValue,
      this.enabled = true,
      this.errorText,
      this.validate = true,
      this.textInputType = TextInputType.text,
      this.obscureText = false,
      this.charactersCondition = 0});

  TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    _textController = TextEditingController(text: currentValue);
    _textController
      ..selection = TextSelection.collapsed(offset: currentValue.length);

    return TextFormField(
      obscureText: obscureText,
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

            if (charactersCondition > 0 && value.length < charactersCondition) {
              return errorText;
            }
          }

          return null;
        });
  }
}
