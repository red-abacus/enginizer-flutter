import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/promotions/providers/create-promotion.provider.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:app/modules/shared/widgets/datepicker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePromotionInfoForm extends StatefulWidget {
  final Function refreshState;

  CreatePromotionInfoForm({this.refreshState});

  @override
  _CreatePromotionInfoFormState createState() {
    return _CreatePromotionInfoFormState();
  }
}

class _CreatePromotionInfoFormState extends State<CreatePromotionInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  CreatePromotionProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<CreatePromotionProvider>(context);
    _provider.informationFormState = _formKey;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_provider.createPromotionRequest.promotionId != null)
              _activeWidget(),
            _titleWidget(),
            _descriptionWidget(),
            _startDateWidget(),
            _endDateWidget(),
            _priceWidget(),
            _discountWidget(),
            if (_provider.createPromotionRequest.presetServiceProviderItem ==
                    null &&
                _provider.createPromotionRequest.promotionId == null)
              _servicesWidget(),
          ],
        ),
      ),
    );
  }

  _activeWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).promotions_create_step_2_stopped,
            style: Theme.of(context).textTheme.bodyText1),
        Switch(
          value: _provider.createPromotionRequest.isActive,
          onChanged: (bool isOn) {
            setState(() {
              _provider.createPromotionRequest.isActive = isOn;
            });
          },
          activeTrackColor: switch_dark_gray,
          inactiveThumbColor: red,
          inactiveTrackColor: switch_dark_gray,
          activeColor: red,
          hoverColor: Colors.blue,
        ),
        Text(
          S.of(context).promotions_create_step_2_active,
          style: Theme.of(context).textTheme.bodyText1,
        )
      ],
    );
  }

  _titleWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.text,
      labelText: S.of(context).general_title,
      listener: (value) {
        _provider.createPromotionRequest.title = value;
      },
      currentValue: _provider.createPromotionRequest.title,
      errorText: S.of(context).promotions_create_step_2_title_warning,
      validate: true,
    );
  }

  _descriptionWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.text,
      labelText: S.of(context).general_description,
      listener: (value) {
        _provider.createPromotionRequest.description = value;
      },
      currentValue: _provider.createPromotionRequest.description,
      errorText: S.of(context).promotions_create_step_2_description_warning,
      validate: true,
    );
  }

  _startDateWidget() {
    return BasicDateField(
        dateTime: _provider.createPromotionRequest.startDate,
        minDate: DateTime.now(),
        maxDate: _provider.createPromotionRequest.endDate != null
            ? _provider.createPromotionRequest.endDate
            : null,
        labelText: S.of(context).general_start_date,
        validator: (value) {
          if (value == null) {
            return S.of(context).promotions_create_step_2_start_date_warning;
          } else {
            return null;
          }
        },
        onChange: (value) {
          setState(() {
            _provider.createPromotionRequest.startDate = value;
          });
        });
  }

  _endDateWidget() {
    return BasicDateField(
        dateTime: _provider.createPromotionRequest.endDate,
        minDate: _provider.createPromotionRequest.startDate != null
            ? _provider.createPromotionRequest.startDate
            : DateTime.now(),
        labelText: S.of(context).general_end_date,
        validator: (value) {
          if (value == null) {
            return S.of(context).promotions_create_step_2_end_date_warning;
          } else {
            return null;
          }
        },
        onChange: (value) {
          setState(() {
            _provider.createPromotionRequest.endDate = value;
          });
        });
  }

  _priceWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.number,
      labelText:
          '${S.of(context).general_price} ${S.of(context).general_currency}',
      listener: (value) {
        try {
          _provider.createPromotionRequest.price = double.parse(value);
        } catch (error) {}
      },
      currentValue: _provider.createPromotionRequest.price != null
          ? _provider.createPromotionRequest.price.toString()
          : '',
      errorText: S.of(context).promotions_create_step_2_price_warning,
      validate: true,
    );
  }

  _discountWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.number,
      labelText: '${S.of(context).general_discount} (%)',
      listener: (value) {
        try {
          _provider.createPromotionRequest.discount = int.parse(value);
        } catch (error) {}
      },
      currentValue: _provider.createPromotionRequest.discount.toString(),
      errorText: S.of(context).promotions_create_step_2_description_warning,
      validate: true,
    );
  }

  _servicesWidget() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: DropdownButtonFormField(
        hint: Text(S.of(context).general_service),
        items: _buildServicesDropdownItems(),
        value: _provider.createPromotionRequest.serviceProviderItem,
        validator: (value) {
          if (value == null) {
            return S.of(context).promotions_create_step_2_service_item_warning;
          } else {
            return null;
          }
        },
        onChanged: (newValue) {
          _provider.createPromotionRequest.serviceProviderItem = newValue;
          widget.refreshState();
        },
      ),
    );
  }

  List<DropdownMenuItem<ServiceProviderItem>> _buildServicesDropdownItems() {
    List<DropdownMenuItem<ServiceProviderItem>> list = [];

    _provider.serviceProviderItemsResponse.items.forEach((item) {
      list.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.getTranslatedServiceName(context)),
        ),
      );
    });

    return list;
  }
}
