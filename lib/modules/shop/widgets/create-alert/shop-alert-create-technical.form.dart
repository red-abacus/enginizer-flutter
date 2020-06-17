import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/providers/cars-make.provider.dart';
import 'package:app/modules/shared/widgets/custom-dropdown-field.dart';
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
  CarsMakeProvider _carsMakeProvider;

  String _customEndMileageValue;
  String _customStartMileageValue;
  String _customStartPrice;
  String _customEndPrice;

  TextEditingController _startMileageController = TextEditingController();
  TextEditingController _endMileageController = TextEditingController();

  TextEditingController _startPriceController = TextEditingController();
  TextEditingController _endPriceController = TextEditingController();

  Widget build(BuildContext context) {
    _carsMakeProvider = Provider.of<CarsMakeProvider>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              S.of(context).online_shop_alert_manufacturer_date,
              style: TextHelper.customTextStyle(null, gray3, null, 14),
            ),
          ),
          _buildDateWidget(),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              S.of(context).general_mileage,
              style: TextHelper.customTextStyle(null, gray3, null, 14),
            ),
          ),
          _buildStartMileageWidget(),
          _buildEndMileageWidget(),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              S.of(context).general_price,
              style: TextHelper.customTextStyle(null, gray3, null, 14),
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
                          _carsMakeProvider.carTechnicalFormState['start_year'],
                      onChanged: (value) {
                        setState(() {
                          _carsMakeProvider
                              .carTechnicalFormState['start_year'] = value;
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
                          _carsMakeProvider.carTechnicalFormState['end_year'],
                      onChanged: (value) {
                        _carsMakeProvider.carTechnicalFormState['end_year'] =
                            value;
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
                      _carsMakeProvider.carTechnicalFormState['start_mileage'],
                  controller: _startMileageController,
                  onChangedListener: (value) {
                    setState(() {
                      _customStartMileageValue = value;
                    });
                  },
                  onValueChanged: (newValue) {
                    _carsMakeProvider.carTechnicalFormState['start_mileage'] =
                        newValue;

                    if (_carsMakeProvider
                            .carTechnicalFormState['end_mileage'] !=
                        null) {
                      try {
                        int startMileage = int.parse(newValue);
                        int endMileage = int.parse(_carsMakeProvider
                            .carTechnicalFormState['end_mileage']);

                        if (startMileage > endMileage) {
                          setState(() {
                            _endMileageController =
                                TextEditingController(text: '');
                            _carsMakeProvider
                                .carTechnicalFormState['end_mileage'] = null;
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
                  value: _carsMakeProvider.carTechnicalFormState['end_mileage'],
                  required: false,
                  controller: _endMileageController,
                  strict: false,
                  onChangedListener: (value) {
                    setState(() {
                      _customEndMileageValue = value;
                    });
                  },
                  onValueChanged: (newValue) {
                    _carsMakeProvider.carTechnicalFormState['end_mileage'] =
                        newValue;

                    if (_carsMakeProvider
                            .carTechnicalFormState['start_mileage'] !=
                        null) {
                      try {
                        int startMileage = int.parse(_carsMakeProvider
                            .carTechnicalFormState['start_mileage']);
                        int endMileage = int.parse(newValue);

                        if (startMileage > endMileage) {
                          setState(() {
                            _carsMakeProvider
                                .carTechnicalFormState['start_mileage'] = null;
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
                      _carsMakeProvider.carTechnicalFormState['start_price'],
                  controller: _startPriceController,
                  onChangedListener: (value) {
                    setState(() {
                      _customStartPrice = value;
                    });
                  },
                  onValueChanged: (newValue) {
                    _carsMakeProvider.carTechnicalFormState['start_price'] =
                        newValue;

                    if (_carsMakeProvider
                            .carTechnicalFormState['end_price'] !=
                        null) {
                      try {
                        int startPrice = int.parse(newValue);
                        int endPrice = int.parse(_carsMakeProvider
                            .carTechnicalFormState['end_price']);

                        if (startPrice > endPrice) {
                          setState(() {
                            _endPriceController =
                                TextEditingController(text: '');
                            _carsMakeProvider
                                .carTechnicalFormState['end_price'] = null;
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
                  value: _carsMakeProvider.carTechnicalFormState['end_price'],
                  required: false,
                  controller: _endPriceController,
                  strict: false,
                  onChangedListener: (value) {
                    setState(() {
                      _customEndPrice = value;
                    });
                  },
                  onValueChanged: (newValue) {
                    _carsMakeProvider.carTechnicalFormState['end_price'] =
                        newValue;

                    if (_carsMakeProvider
                            .carTechnicalFormState['start_price'] !=
                        null) {
                      try {
                        int startPrice = int.parse(_carsMakeProvider
                            .carTechnicalFormState['start_price']);
                        int endPrice = int.parse(newValue);

                        if (startPrice > endPrice) {
                          setState(() {
                            _carsMakeProvider
                                .carTechnicalFormState['start_price'] = null;
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
    List<DropdownMenuItem<int>> list = [];

    for (int i = 0; i < 30; i++) {
      DateTime date = DateTime(DateTime.now().year - i);
      int year = int.parse(DateUtils.stringFromDate(date, 'yyyy'));
      list.add(DropdownMenuItem(value: year, child: Text('$year')));
    }
    return list;
  }

  _buildEndCarYearDropdownItems() {
    int startYear = _carsMakeProvider.carTechnicalFormState['start_year'];

    List<DropdownMenuItem<int>> list = [];

    for (int i = 0; i < 30; i++) {
      DateTime date = DateTime(DateTime.now().year - i);
      int year = int.parse(DateUtils.stringFromDate(date, 'yyyy'));

      if (startYear == null || year > startYear) {
        list.add(DropdownMenuItem(value: year, child: Text('$year')));
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
