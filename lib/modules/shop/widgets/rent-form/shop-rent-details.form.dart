import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/shop/providers/shop-appointment.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopRentDetailsForm extends StatefulWidget {
  @override
  _ShopRentDetailsFormState createState() => _ShopRentDetailsFormState();
}

class _ShopRentDetailsFormState extends State<ShopRentDetailsForm> {
  ShopAppointmentProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ShopAppointmentProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _titleContainer('${S.of(context).online_shop_provider}:'),
        _providerContainer(),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: _titleContainer('${S.of(context).online_shop_car}:'),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: _subtitleContainer(_provider.car?.brand?.name ?? 'n/a'),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: _titleContainer('${S.of(context).online_shop_taking_over}:'),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: _subtitleContainer(_provider.startDateTime != null
              ? DateUtils.stringFromDate(
                  _provider.startDateTime.date, 'dd/MM/yyyy HH:mm')
              : 'n/a'),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: _titleContainer('${S.of(context).online_shop_delivery}:'),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: _subtitleContainer(_provider.endDateTime != null
              ? DateUtils.stringFromDate(
                  _provider.endDateTime.date, 'dd/MM/yyyy HH:mm')
              : 'n/a'),
        ),
      ],
    );
  }

  _titleContainer(String text) {
    return Text(
      text,
      style: TextHelper.customTextStyle(color: gray3, size: 16),
    );
  }

  _subtitleContainer(String text) {
    return Text(
      text,
      style: TextHelper.customTextStyle(color: gray2, size: 16),
    );
  }

  _providerContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            child: ClipOval(
              child: FadeInImage.assetNetwork(
                image: _provider.serviceProvider?.image ?? '',
                placeholder: ServiceProvider.defaultImage(),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: _titleContainer(_provider.serviceProvider?.name ?? 'n/a'),
            ),
          )
        ],
      ),
    );
  }
}
