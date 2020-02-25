import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BasicDateField extends StatelessWidget {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  Function validator;
  Function onChange;
  String labelText;
  DateTime dateTime;

  BasicDateField({this.onChange, this.labelText = '', this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        format: dateFormat,
        decoration: InputDecoration(labelText: labelText),
        initialValue: this.dateTime,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
        validator: (value) {
          return validator(value);
        },
        onChanged: (value) {
          onChange(value);
        },
      ),
    ]);
  }
}
