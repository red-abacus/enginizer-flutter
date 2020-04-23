import 'package:app/generated/l10n.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/providers/cars.provider.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/dashboard/providers/dashboard.provider.dart';
import 'package:app/modules/dashboard/widgets/dashboard-chart.widget.dart';
import 'package:app/modules/shared/widgets/datepicker.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static const String route = '/dashboard';
  static final IconData icon = Icons.dashboard;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _initDone = false;
  bool _isLoading = false;

  DashboardProvider _dashboardProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<CarsProvider>(
      builder: (context, carsProvider, _) => Scaffold(
        body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _getContent(),
        ),
      ),
    );
  }

  _getContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              S.of(context).dashboard_expenses,
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 20),
            ),
          ),
          _filterButtons(),
          _carDropdownWidget(),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: DashboardChartWidget.withSampleData(),
          )
        ],
      ),
    );
  }

  _filterButtons() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(right: 5),
                height: 60,
                child: BasicDateField(
                  maxDate: _dashboardProvider.endDate,
                  labelText: S.of(context).dashboard_start_date,
                  onChange: (value) {
                    setState(() {
                      _dashboardProvider.startDate = value;
                    });
                  },
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 5),
                height: 60,
                child: BasicDateField(
                  minDate: _dashboardProvider.startDate,
                  labelText: S.of(context).dashboard_end_date,
                  onChange: (value) {
                    setState(() {
                      _dashboardProvider.endDate = value;
                    });
                  },
                ),
              )),
        ],
      ),
    );
  }

  _carDropdownWidget() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20),
      child: DropdownButtonFormField(
        value: _dashboardProvider.selectedCar,
        isDense: true,
        hint: Text(
          S.of(context).dashboard_select_car,
          style: TextHelper.customTextStyle(null, Colors.grey, null, 15),
        ),
        items: _carsDropdownItems(),
        onChanged: (newValue) {
          setState(() {
            _dashboardProvider.selectedCar = newValue;
          });
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _dashboardProvider = Provider.of<DashboardProvider>(context);
      _dashboardProvider.initialise();

      setState(() {
        _isLoading = true;
      });

      _loadData();
    }
    _initDone = true;
    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _dashboardProvider.loadCars().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_GET_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_car_get, context);

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _carsDropdownItems() {
    List<DropdownMenuItem<Car>> list = [];

    _dashboardProvider.cars.forEach((car) {
      list.add(
          DropdownMenuItem(value: car, child: Text(car.registrationNumber)));
    });

    return list;
  }
}
