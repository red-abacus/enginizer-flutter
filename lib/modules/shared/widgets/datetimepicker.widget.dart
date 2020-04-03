import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BasicDateTimePicker extends StatelessWidget {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  Function validator;
  Function onChange;
  String labelText;
  DateTime dateTime;

  BasicDateTimePicker(
      {this.onChange, this.labelText = '', this.validator, this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
        format: dateFormat,
        decoration: InputDecoration(labelText: labelText),
        initialValue: this.dateTime,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              initialDate: currentValue ?? DateTime.now(),
              firstDate: DateUtils.addHourToDate(DateTime.now(), -24),
              lastDate: DateTime(2100));

          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
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
