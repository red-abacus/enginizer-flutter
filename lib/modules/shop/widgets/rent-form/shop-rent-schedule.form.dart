import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/custom-datepicker.widget.dart';
import 'package:app/modules/shop/providers/shop-appointment.provider.dart';
import 'package:app/utils/constants.dart';
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
        Container(
          margin: EdgeInsets.only(top: 20),
          child: CustomDatePickerField(
            activateTime: true,
            dateFormat: 'dd/MM/yyyy HH:mm',
            minDate: _provider.shopItem?.getStartDate(),
            maxDate: _provider.endDateTime ?? _provider.shopItem?.getEndDate(),
            dateTime: _provider.startDateTime,
            labelText: '${S.of(context).general_from}:',
            onChange: (date) {
              setState(() {
                _provider.startDateTime = date;
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: CustomDatePickerField(
            activateTime: true,
            dateFormat: 'dd/MM/yyyy HH:mm',
            dateTime: _provider.endDateTime,
            minDate: _provider.startDateTime ?? _provider.shopItem?.getStartDate(),
            maxDate: _provider.shopItem?.getEndDate(),
            labelText: '${S.of(context).general_up_to}:',
            onChange: (date) {
              setState(() {
                _provider.endDateTime = date;
              });
            },
          ),
        ),
      ],
    );
  }
}
