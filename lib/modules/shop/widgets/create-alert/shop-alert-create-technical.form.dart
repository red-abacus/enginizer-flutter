import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/custom-dropdown-field.dart';
import 'package:app/modules/shop/providers/shop-alert-make.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopAlertCreateTechnicalForm extends StatefulWidget {
  @override
  ShopAlertCreateTechnicalFormState createState() =>
      ShopAlertCreateTechnicalFormState();
}

class ShopAlertCreateTechnicalFormState
    extends State<ShopAlertCreateTechnicalForm> {
  ShopAlertMakeProvider _provider;

  String _customEndMileageValue;
  String _customStartMileageValue;
  String _customStartPrice;
  String _customEndPrice;

  TextEditingController _startMileageController = TextEditingController();
  TextEditingController _endMileageController = TextEditingController();

  TextEditingController _startPriceController = TextEditingController();
  TextEditingController _endPriceController = TextEditingController();

  Widget build(BuildContext context) {
    _provider = Provider.of<ShopAlertMakeProvider>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              S.of(context).online_shop_alert_manufacturer_date,
              style: TextHelper.customTextStyle(color: gray3),
            ),
          ),
          _buildDateWidget(),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              S.of(context).general_mileage,
              style: TextHelper.customTextStyle(color: gray3),
            ),
          ),
          _buildStartMileageWidget(),
          _buildEndMileageWidget(),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              S.of(context).general_price,
              style: TextHelper.customTextStyle(color: gray3),
            ),
          ),
          _buildStartPriceWidget(),
          _buildEndPriceWidget()
        ],
      ),
    );
  }

  _buildDateWidget() {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(width: 0.5, color: gray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text(S.of(context).general_start_date),
                      items: _buildStartCarYearDropdownItems(),
                      value:
                      _provider.shopAlert.startYear?.toString(),
                      onChanged: (value) {
                        setState(() {
                          _provider.shopAlert.startYear = int.parse(value);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(width: 0.5, color: gray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text(S.of(context).general_end_date),
                      items: _buildEndCarYearDropdownItems(),
                      value:
                      _provider.shopAlert.endYear?.toString(),
                      onChanged: (value) {
                        _provider.shopAlert.endYear =
                            int.parse(value);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildStartMileageWidget() {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Container(
        margin: EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 0.5, color: gray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: DropDownField(
                  required: false,
                  strict: false,
                  value:
                  _provider.shopAlert.startMileage.toString(),
                  controller: _startMileageController,
                  onChangedListener: (value) {
                    setState(() {
                      _customStartMileageValue = value;
                    });
                  },
                  onValueChanged: (newValue) {
                    _provider.shopAlert.startMileage =
                        int.parse(newValue);

                    if (_provider.shopAlert.endMileage !=
                        null) {
                      try {
                        int startMileage = int.parse(newValue);
                        int endMileage = _provider.shopAlert.endMileage;

                        if (startMileage > endMileage) {
                          setState(() {
                            _endMileageController =
                                TextEditingController(text: '');
                            _provider.shopAlert.endMileage = null;
                          });
                        }
                      } catch (error) {}
                    }
                  },
                  labelText: S.of(context).general_from,
                  items: _buildStartMileageDropdownItems(),
                  setter: (dynamic newValue) {}),
            )
          ],
        ),
      ),
    );
  }

  _buildEndMileageWidget() {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Container(
        margin: EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 0.5, color: gray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: DropDownField(
                  value: _provider.shopAlert.endMileage.toString(),
                  required: false,
                  controller: _endMileageController,
                  strict: false,
                  onChangedListener: (value) {
                    setState(() {
                      _customEndMileageValue = value;
                    });
                  },
                  onValueChanged: (newValue) {
                    _provider.shopAlert.endMileage =
                        int.parse(newValue);

                    if (_provider.shopAlert.startMileage !=
                        null) {
                      try {
                        int startMileage = _provider.shopAlert.startMileage;
                        int endMileage = int.parse(newValue);

                        if (startMileage > endMileage) {
                          setState(() {
                            _provider.shopAlert.startMileage = null;
                            _startMileageController =
                                TextEditingController(text: '');
                          });
                        }
                      } catch (error) {}
                    }
                  },
                  labelText: S.of(context).general_up_to,
                  items: _buildEndMileageDropdownItems(),
                  setter: (dynamic newValue) {}),
            )
          ],
        ),
      ),
    );
  }

  _buildStartPriceWidget() {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Container(
        margin: EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 0.5, color: gray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: DropDownField(
                  required: false,
                  strict: false,
                  value:
                  _provider.shopAlert.startPrice.toString(),
                  controller: _startPriceController,
                  onChangedListener: (value) {
                    setState(() {
                      _customStartPrice = value;
                    });
                  },
                  onValueChanged: (newValue) {
                    _provider.shopAlert.startPrice =
                        int.parse(newValue);

                    if (_provider.shopAlert.endPrice !=
                        null) {
                      try {
                        int startPrice = int.parse(newValue);
                        int endPrice = _provider.shopAlert.endPrice;

                        if (startPrice > endPrice) {
                          setState(() {
                            _endPriceController =
                                TextEditingController(text: '');
                            _provider.shopAlert.endPrice = null;
                          });
                        }
                      } catch (error) {}
                    }
                  },
                  labelText: S.of(context).general_from,
                  items: _buildStartPriceDropdownItems(),
                  setter: (dynamic newValue) {}),
            )
          ],
        ),
      ),
    );
  }

  _buildEndPriceWidget() {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Container(
        margin: EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(width: 0.5, color: gray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: DropDownField(
                  value: _provider.shopAlert.endPrice.toString(),
                  required: false,
                  controller: _endPriceController,
                  strict: false,
                  onChangedListener: (value) {
                    setState(() {
                      _customEndPrice = value;
                    });
                  },
                  onValueChanged: (newValue) {
                    _provider.shopAlert.endPrice =
                        int.parse(newValue);

                    if (_provider.shopAlert.startPrice !=
                        null) {
                      try {
                        int startPrice = _provider.shopAlert.startPrice;
                        int endPrice = int.parse(newValue);

                        if (startPrice > endPrice) {
                          setState(() {
                            _provider.shopAlert.startPrice = null;
                            _startPriceController =
                                TextEditingController(text: '');
                          });
                        }
                      } catch (error) {}
                    }
                  },
                  labelText: S.of(context).general_up_to,
                  items: _buildEndPriceDropdownItems(),
                  setter: (dynamic newValue) {}),
            )
          ],
        ),
      ),
    );
  }

  _buildStartCarYearDropdownItems() {
    List<DropdownMenuItem<String>> list = [];

    for (int i = 0; i < 30; i++) {
      DateTime date = DateTime(DateTime.now().year - i);
      int year = int.parse(DateUtils.stringFromDate(date, 'yyyy'));
      list.add(DropdownMenuItem(value: year.toString(), child: Text('$year')));
    }
    return list;
  }

  _buildEndCarYearDropdownItems() {
    int startYear = _provider.shopAlert.startYear;

    List<DropdownMenuItem<String>> list = [];

    for (int i = 0; i < 30; i++) {
      DateTime date = DateTime(DateTime.now().year - i);
      int year = int.parse(DateUtils.stringFromDate(date, 'yyyy'));

      if (startYear == null || year > startYear) {
        list.add(DropdownMenuItem(value: year.toString(), child: Text('$year')));
      }
    }
    return list;
  }

  _buildStartMileageDropdownItems() {
    List<String> list = [
      '5000',
      '10000',
      '25000',
      '500000',
      '750000',
      '100000',
      '125000',
      '1500000',
      '200000'
    ];

    if (_customStartMileageValue != null) {
      list.insert(0, _customStartMileageValue);
    }

    return list;
  }

  _buildEndMileageDropdownItems() {
    List<String> list = [
      '5000',
      '10000',
      '25000',
      '500000',
      '750000',
      '100000',
      '125000',
      '1500000',
      '200000'
    ];

    if (_customEndMileageValue != null) {
      list.insert(0, _customEndMileageValue);
    }

    return list;
  }

  _buildStartPriceDropdownItems() {
    List<String> list = [
      '2000',
      '3000',
      '5000',
      '10000',
      '20000',
      '30000',
      '40000',
      '50000',
      '60000',
      '80000',
      '100000'
    ];

    if (_customStartPrice != null) {
      list.insert(0, _customStartPrice);
    }

    return list;
  }

  _buildEndPriceDropdownItems() {
    List<String> list = [
      '5000',
      '10000',
      '25000',
      '500000',
      '750000',
      '100000',
      '125000',
      '1500000',
      '200000'
    ];

    if (_customEndPrice != null) {
      list.insert(0, _customEndPrice);
    }

    return list;
  }
}
