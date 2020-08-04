import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

class CustomDatePickerField extends StatelessWidget {
  String dateFormat = 'yyyy-MM-dd';
  Function onChange;
  String labelText;

  DateTime dateTime;
  DateTime minDate;
  DateTime maxDate;

  bool activateTime = false;

  CustomDatePickerField(
      {this.onChange,
      this.labelText = '',
      this.minDate,
      this.maxDate,
      this.dateTime,
      this.activateTime,
      this.dateFormat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this.labelText,
            style: TextHelper.customTextStyle(color: gray3),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            margin: EdgeInsets.only(top: 10),
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: gray_20),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    dateTime != null
                        ? DateUtils.stringFromDate(dateTime, dateFormat)
                        : '',
                    style: TextHelper.customTextStyle(color: gray3, size: 16),
                    maxLines: 1,
                  ),
                ),
                Icon(Icons.date_range),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showPicker(BuildContext context) async {
    DateTime selectedDate = await showDatePicker(
        context: context,
        firstDate: minDate != null ? minDate : DateTime(1900),
        initialDate: dateTime != null
            ? dateTime
            : DateTime.now().isAfter(minDate) ? DateTime.now() : minDate,
        lastDate:
            maxDate != null ? maxDate : DateTime(DateTime.now().year + 100));

    if (selectedDate != null && activateTime) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
      );

      selectedDate = DateTimeField.combine(selectedDate, time);

      if (onChange != null) {
        onChange(selectedDate);
      }
    }
    else {
      if (onChange != null) {
        onChange(selectedDate);
      }
    }
  }
}
