import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopAppointmentServiceCard extends StatelessWidget {
  ShopAppointmentServiceCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _checkboxContainer(),
              _textContainer(),
              _priceContainer(),
            ],
          ),
        ),
      );
    });
  }

  _checkboxContainer() {
    return Container(
      child: Icon(
        Icons.check_box_outline_blank,
        color: red,
      ),
    );
  }

  _textContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          'Serviciu sau subserviciu',
          style: TextStyle(
              color: Colors.black87,
              fontFamily: 'Lato',
              fontWeight: FontWeight.normal,
              fontSize: 14),
        ),
      ),
    );
  }

  _priceContainer() {
    return Column(
      children: <Widget>[
        Text(
          '200 lei',
          style: TextStyle(
            fontSize: 12,
            color: black_text,
            fontFamily: 'Lato',
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Text(
          '100 lei',
          style: TextHelper.customTextStyle(null, red, FontWeight.normal, 14),
        ),
      ],
    );
  }
}
