import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/cars/models/car-timetable.model.dart';
import 'package:app/modules/shop/providers/shop-appointment.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopRentScheduleForm extends StatefulWidget {
  @override
  _ShopRentScheduleFormState createState() => _ShopRentScheduleFormState();
}

class _ShopRentScheduleFormState extends State<ShopRentScheduleForm> {
  ShopAppointmentProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ShopAppointmentProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${S.of(context).online_shop_rent_car_choose_date_title}:',
          style: TextHelper.customTextStyle(size: 16, color: gray3),
        ),
        GridView.count(
          childAspectRatio: 10 / 6,
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          children: List.generate(
            _provider.carTimetable.length,
            (int index) {
              return _buildGridCard(_provider.carTimetable[index]);
            },
          ),
        )
      ],
    );
  }

  Widget _buildGridCard(CarTimetable carTimetable) {
    Color boxBackground = Colors.transparent;
    Color textColor = black_text;
    double alpha = 1.0;

    if (carTimetable.getStatus() == DateEntryStatus.Booked) {
      alpha = 0.4;
      boxBackground = red;
      textColor = Colors.white;
    }

    if (_provider.startDateTime != null) {
      if (carTimetable.date.isBefore(_provider.startDateTime.date)) {
        alpha = 0.4;
      } else if (carTimetable.date.isAfter(_provider.startDateTime.date)) {
        if (_provider.endDateTime != null) {
          if (carTimetable.date.isBefore(_provider.endDateTime.date)) {
            boxBackground = red;
            textColor = Colors.white;
          } else if (carTimetable.date.isAfter(_provider.endDateTime.date)) {
            alpha = 0.4;
          } else {
            boxBackground = red;
            textColor = Colors.white;
          }
        } else {
          CarTimetable firstBooked;

          for (CarTimetable carTimetable in _provider.carTimetable) {
            if (carTimetable.date
                .isAfter(_provider.startDateTime.date) &&
                carTimetable.getStatus() == DateEntryStatus.Booked) {
              firstBooked = carTimetable;
              break;
            }
          }

          if (firstBooked != null && carTimetable.date.isAfter(firstBooked.date)) {
            alpha = 0.4;
          }
        }
      } else {
        boxBackground = red;
        textColor = Colors.white;
      }
    }

    return Container(
      width: 100,
      height: 20,
      child: Opacity(
        opacity: alpha,
        child: Container(
          child: new FlatButton(
            color: boxBackground,
            onPressed: () => {_selectTimetable(carTimetable)},
            child: new Text(
                DateUtils.stringFromDate(carTimetable.date, "dd MMM"),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    color: textColor),
                textAlign: TextAlign.center),
          ),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: red, width: 1),
            borderRadius: new BorderRadius.all(
              const Radius.circular(5.0),
            ),
          ),
        ),
      ),
    );
  }

  _selectTimetable(CarTimetable carTimetable) {
    if (_provider.startDateTime == null) {
      setState(() {
        _provider.endDateTime = null;
        _provider.startDateTime = carTimetable;
      });
    } else {
      if (_provider.endDateTime == null) {
        CarTimetable firstBooked;

        for (CarTimetable carTimetable in _provider.carTimetable) {
          if (carTimetable.date.isAfter(_provider.startDateTime.date) &&
              carTimetable.getStatus() == DateEntryStatus.Booked) {
            firstBooked = carTimetable;
            break;
          }
        }

        if (_provider.startDateTime.date.isBefore(carTimetable.date)) {
          if (firstBooked != null) {
            if (firstBooked.date.isAfter(carTimetable.date)) {
              setState(() {
                _provider.endDateTime = carTimetable;
              });
            }
            else {
              setState(() {
                _provider.startDateTime = carTimetable;
              });
            }
          } else {
            setState(() {
              _provider.endDateTime = carTimetable;
            });
          }
        } else {
          setState(() {
            _provider.startDateTime = carTimetable;
          });
        }
      } else {
        setState(() {
          _provider.startDateTime = carTimetable;
          _provider.endDateTime = null;
          ;
        });
      }
    }
  }
}
