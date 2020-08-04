import 'package:app/generated/l10n.dart';
import 'package:app/modules/parts/providers/part-create.provider.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartCreateInfoWidget extends StatefulWidget {
  @override
  _PartCreateInfoWidgetState createState() {
    return _PartCreateInfoWidgetState();
  }
}

class _PartCreateInfoWidgetState extends State<PartCreateInfoWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  PartCreateProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<PartCreateProvider>(context);
    _provider.formState = _formKey;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _nameWidget(),
            _codeWidget(),
            _priceWidget(),
            _vtaWidget(),
            _additionWidget(),
            _guaranteeWidget(),
            if (_provider.request.guarantee > 0)
              _guaranteeFieldWidget()
          ],
        ),
      ),
    );
  }

  _nameWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.text,
      labelText: S.of(context).part_create_name_title,
      listener: (value) {
        _provider.request.name = value;
      },
      currentValue: _provider.request.name,
      errorText: S.of(context).part_create_name_title_error,
      validate: true,
    );
  }

  _codeWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.text,
      labelText: S.of(context).part_create_code_title,
      listener: (value) {
        _provider.request.code = value;
      },
      currentValue: _provider.request.code,
      errorText: S.of(context).part_create_code_title_error,
      validate: true,
    );
  }

  _priceWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.number,
      labelText: S.of(context).part_create_price_title,
      listener: (value) {
        _provider.request.price = double.parse(value);
      },
      currentValue: _provider.request.price != null
          ? _provider.request.price.toString()
          : '',
      errorText: S.of(context).part_create_price_error,
      validate: true,
    );
  }

  _vtaWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.number,
      labelText: S.of(context).part_create_vta_title,
      listener: (value) {
        _provider.request.vta = double.parse(value);
      },
      currentValue: _provider.request.vta.toString(),
      validate: false,
    );
  }

  _additionWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.number,
      labelText: S.of(context).part_create_addition_title,
      listener: (value) {
        _provider.request.addition = double.parse(value);
      },
      currentValue: _provider.request.addition.toString(),
      validate: false,
    );
  }

  _guaranteeWidget() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Text(
            S.of(context).part_create_guarantee_title,
            style:
                TextHelper.customTextStyle(color: gray2, weight: FontWeight.normal, size: 16),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Checkbox(
              onChanged: (bool value) {
                setState(() {
                  _provider.request.guarantee = 1;
                });
              },
              value: _provider.request.guarantee > 0,
            ),
          )
        ],
      ),
    );
  }

  _guaranteeFieldWidget() {
    return CustomTextFormField(
      textInputType: TextInputType.number,
      listener: (value) {
        _provider.request.guarantee = int.parse(value);
      },
      currentValue: _provider.request.guarantee.toString(),
      validate: false,
    );
  }
//
//  _clientKeepPartsWidget() {
//    return Container(
//      margin: EdgeInsets.only(top: 5),
//      child: Row(
//        children: <Widget>[
//          Text(
//            S.of(context).appointment_consultant_car_form_client_keep_parts,
//            style:
//                TextHelper.customTextStyle(null, gray2, FontWeight.normal, 16),
//          ),
//          Container(
//            margin: EdgeInsets.only(left: 5),
//            child: Checkbox(
//              onChanged: (bool value) {
//                setState(() {
////                  _provider.receiveFormRequest.clientKeepParts = value;
//                });
//              },
//              value: false,
//            ),
//          )
//        ],
//      ),
//    );
//  }
//
//  _oilChangeWidget() {
//    return Container(
//      margin: EdgeInsets.only(top: 5),
//      child: CustomTextFormField(
//        labelText: S.of(context).appointment_consultant_car_form_oil_change,
//        listener: (value) {},
//        currentValue: '',
//        errorText:
//            S.of(context).appointment_consultant_car_form_oil_change_error,
//        validate: false,
//      ),
//    );
//  }
//
//  _addTitle(String title) {
//    return Container(
//      child: Text(
//        title,
//        style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
//      ),
//    );
//  }
}
