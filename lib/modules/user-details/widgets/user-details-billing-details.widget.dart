import 'package:app/generated/l10n.dart';
import 'package:app/modules/authentication/providers/user.provider.dart';
import 'package:app/modules/user-details/enums/invoice-type.enum.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/string.utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsBillingDetailsWidget extends StatefulWidget {
  final Function saveBillingDetails;

  UserDetailsBillingDetailsWidget({this.saveBillingDetails});

  @override
  _UserDetailsBillingDetailsWidgetState createState() =>
      _UserDetailsBillingDetailsWidgetState();
}

class _UserDetailsBillingDetailsWidgetState
    extends State<UserDetailsBillingDetailsWidget> {
  UserProvider _provider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<UserProvider>(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                invoiceTypeContainer(),
                if (_provider.changeBillingInfoRequest?.invoiceType ==
                    InvoiceType.Individual)
                  _individualContainer(),
                if (_provider.changeBillingInfoRequest?.invoiceType ==
                    InvoiceType.Company)
                  _companyContainer(),
                _saveButtonContainer(),
              ],
            ),
          )),
    );
  }

  invoiceTypeContainer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.of(context).user_details_billing_info_individual,
          style: TextHelper.customTextStyle(color: gray3, size: 14),
        ),
        Switch(
          value: _provider.changeBillingInfoRequest.invoiceType ==
              InvoiceType.Company,
          onChanged: (bool isOn) {
            setState(() {
              if (isOn) {
                _provider.changeBillingInfoRequest.invoiceType =
                    InvoiceType.Company;

                if (widget.saveBillingDetails != null) {
                  widget.saveBillingDetails();
                }
              } else {
                _provider.changeBillingInfoRequest.invoiceType =
                    InvoiceType.Individual;

                if (widget.saveBillingDetails != null) {
                  widget.saveBillingDetails();
                }
              }
            });
          },
          activeTrackColor: switch_dark_gray,
          inactiveThumbColor: red,
          inactiveTrackColor: switch_dark_gray,
          activeColor: red,
          hoverColor: Colors.blue,
        ),
        Text(
          S.of(context).user_details_billing_info_company,
          style: TextHelper.customTextStyle(color: gray3, size: 14),
        ),
      ],
    );
  }

  _individualContainer() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                '${S.of(context).user_details_billing_info_cnp}: ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                keyboardType: TextInputType.number,
                initialValue:
                    _provider.changeBillingInfoRequest?.userPersonalData?.cnp ??
                        '',
                style: TextHelper.customTextStyle(
                    color: black_text, weight: FontWeight.bold, size: 16),
                validator: (value) {
                  if (value.isEmpty || value.length != 13) {
                    return S.of(context).user_details_cnp_alert;
                  } else {
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() {
                    _provider.changeBillingInfoRequest?.userPersonalData?.cnp =
                        val;
                  });
                },
              ),
            )),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                '${S.of(context).user_details_billing_info_home_address}: ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                autovalidate: true,
                initialValue: _provider
                        .changeBillingInfoRequest?.userPersonalData?.address ??
                    '',
                style: TextHelper.customTextStyle(
                    color: black_text, weight: FontWeight.bold, size: 16),
                onChanged: (val) {
                  setState(() {
                    _provider.changeBillingInfoRequest?.userPersonalData
                        ?.address = val;
                  });
                },
              ),
            ))
          ],
        )
      ],
    );
  }

  _companyContainer() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              child: Text(
                '${S.of(context).user_details_billing_info_fiscal_name}: ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                initialValue: _provider.changeBillingInfoRequest
                        ?.userCompanyData?.fiscalName ??
                    '',
                style: TextHelper.customTextStyle(
                    color: black_text, weight: FontWeight.bold, size: 16),
                onChanged: (val) {
                  setState(() {
                    _provider.changeBillingInfoRequest?.userCompanyData
                        ?.fiscalName = val;
                  });
                },
              ),
            )),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                '${S.of(context).user_details_billing_info_address}: ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: TextFormField(
                  initialValue: _provider
                          .changeBillingInfoRequest?.userCompanyData?.address ??
                      '',
                  style: TextHelper.customTextStyle(
                      color: black_text, weight: FontWeight.bold, size: 16),
                  onChanged: (val) {
                    setState(() {
                      _provider.changeBillingInfoRequest?.userCompanyData
                          ?.address = val;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                '${S.of(context).user_details_billing_info_contact_person}: ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: TextFormField(
                  initialValue: _provider.changeBillingInfoRequest
                          ?.userCompanyData?.contactPerson ??
                      '',
                  style: TextHelper.customTextStyle(
                      color: black_text, weight: FontWeight.bold, size: 16),
                  onChanged: (val) {
                    setState(() {
                      _provider.changeBillingInfoRequest?.userCompanyData
                          ?.contactPerson = val;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                '${S.of(context).user_details_billing_info_cui}: ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: TextFormField(
                  initialValue: _provider
                          .changeBillingInfoRequest?.userCompanyData?.cui ??
                      '',
                  style: TextHelper.customTextStyle(
                      color: black_text, weight: FontWeight.bold, size: 16),
                  onChanged: (val) {
                    setState(() {
                      _provider.changeBillingInfoRequest?.userCompanyData?.cui =
                          val;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                '${S.of(context).user_details_billing_info_registration_no}: ',
                style: TextHelper.customTextStyle(color: gray2, size: 14),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: TextFormField(
                  initialValue: _provider.changeBillingInfoRequest
                          ?.userCompanyData?.registrationNo ??
                      '',
                  style: TextHelper.customTextStyle(
                      color: black_text, weight: FontWeight.bold, size: 16),
                  validator: (value) {
                    if (!StringUtils.registrationNumberMatches(value)) {
                      return S.of(context).user_profile_registration_format_error;
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      _provider.changeBillingInfoRequest?.userCompanyData
                          ?.registrationNo = val;
                    });
                  },
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  _saveButtonContainer() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 20, top: 20),
        child: FlatButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              if (widget.saveBillingDetails != null) {
                widget.saveBillingDetails();
              }
            }
          },
          color: red,
          textColor: Colors.white,
          child: Text(S.of(context).general_save_changes),
        ),
      ),
    );
  }
}
