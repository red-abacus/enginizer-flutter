import 'package:app/generated/l10n.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/stack-chart.widget.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetailsGraphConsultantWidget extends StatefulWidget {
  @override
  _UserDetailsGraphConsultantWidgetState createState() {
    return _UserDetailsGraphConsultantWidgetState();
  }
}

class _UserDetailsGraphConsultantWidgetState
    extends State<UserDetailsGraphConsultantWidget> {
  DateTime _startDate;
  DateTime _endDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _startDateContainer(context),
              ),
              Expanded(
                flex: 1,
                child: _endDateContainer(context),
              ),
            ],
          ),
          _chartContainer(),
          Container(
            margin: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 14,
                      height: 14,
                      color: red_graph,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4),
                      child: Text(
                        S.of(context).user_profile_your_time,
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 14),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 14,
                      height: 14,
                      color: grey_graph,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4),
                      child: Text(
                        S.of(context).user_profile_normalized_time,
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 14),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _startDateContainer(BuildContext context) {
    return Container(
      child: Align(
        child: InkWell(
          onTap: () => {_showStartDatePicker(context)},
          child: _startDate != null
              ? Text(
                  DateUtils.stringFromDate(
                    _startDate,
                    'dd MMMM yyyy',
                  ),
                  style: TextHelper.customTextStyle(
                      null, gray3, FontWeight.bold, 16),
                )
              : _startDatePickerContainer(),
        ),
      ),
    );
  }

  _startDatePickerContainer() {
    return Container(
      width: 90,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: gray_80),
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 4),
            child: Text(
              S.of(context).user_profile_start_date,
              style: TextHelper.customTextStyle(
                  null, Colors.grey, FontWeight.normal, 12),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6),
            child: Icon(
              Icons.today,
              color: gray3,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  _showStartDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate:
                _endDate != null ? _endDate : _startDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: _endDate != null ? _endDate : DateTime(2100))
        .then((endDate) {
      setState(() {
        _startDate = endDate;
      });
    });
  }

  _endDateContainer(BuildContext context) {
    return Container(
      child: Align(
        child: InkWell(
            onTap: () => {_showEndDatePicker(context)},
            child: _endDate != null
                ? Text(
                    DateUtils.stringFromDate(
                      _endDate,
                      'dd MMMM yyyy',
                    ),
                    style: TextHelper.customTextStyle(
                        null, gray3, FontWeight.bold, 16),
                  )
                : _endDatePickerContainer()),
      ),
    );
  }

  _endDatePickerContainer() {
    return Container(
      width: 90,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: gray_80),
        borderRadius: BorderRadius.all(const Radius.circular(4.0)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 4),
            child: Text(
              S.of(context).user_profile_end_date,
              style: TextHelper.customTextStyle(
                  null, Colors.grey, FontWeight.normal, 12),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6),
            child: Icon(
              Icons.today,
              color: gray3,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  _showEndDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate:
                _startDate != null ? _startDate : _endDate ?? DateTime.now(),
            firstDate: _startDate != null ? _startDate : DateTime(1900),
            lastDate: DateTime(2100))
        .then((endDate) {
      setState(() {
        _endDate = endDate;
      });
    });
  }

  _chartContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      height: 200,
      child: StackedAreaCustomColorLineChart.withSampleData(),
    );
  }
}
