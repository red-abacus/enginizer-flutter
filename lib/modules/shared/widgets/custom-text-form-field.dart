import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController _textController;

  String currentValue;
  Function listener;

  CustomTextFormField({this.listener, this.currentValue});

  @override
  Widget build(BuildContext context) {
    _textController = TextEditingController(text: currentValue);
    _textController..selection = TextSelection.collapsed(offset: currentValue.length);

    return TextFormField(
        decoration:
        InputDecoration(labelText: S.of(context).appointment_create_issues),
        onChanged: (value) {
//          _textController
//            ..text = value
//            ..selection = TextSelection.collapsed(offset: value.length);

          listener(value);
        },
        controller: _textController,
        validator: (value) {
          if (value.isEmpty) {
            return S.of(context).appointment_create_error_issueCannotBeEmpty;
          } else {
            return null;
          }
        });
  }
}