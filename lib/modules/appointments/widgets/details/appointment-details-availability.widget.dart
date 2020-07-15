import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/providers/appointment-consultant.provider.dart';
import 'package:app/modules/cars/models/car-timetable.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shop/services/shop.service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsAvailabilityWidget extends StatefulWidget {
  @override
  _AppointmentDetailsAvailabilityWidgetState createState() {
    return _AppointmentDetailsAvailabilityWidgetState();
  }
}

class _AppointmentDetailsAvailabilityWidgetState
    extends State<AppointmentDetailsAvailabilityWidget> {
  bool _isLoading = false;
  bool _initDone = false;

  AppointmentConsultantProvider _provider;

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Center(child: CircularProgressIndicator()) : GridView
        .count(
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
    );
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<AppointmentConsultantProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      _loadData();
    }

    _initDone = true;
    _provider.initDone = true;

    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .getShopItemDetails(_provider.selectedAppointmentDetail.promotionId)
          .then((value) async {
        await _provider
            .getCarTimetable(_provider.getCarTimetableRequest())
            .then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    } catch (error) {
      if (error.toString().contains(CarService.CAR_TIMETABLE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S
            .of(context)
            .general_error,
            S
                .of(context)
                .exception_car_timetable, context);
      } else if (error
          .toString()
          .contains(ShopService.GET_SHOP_ITEM_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S
            .of(context)
            .general_error,
            S
                .of(context)
                .exception_car_timetable, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildGridCard(CarTimetable carTimetable) {
    Color boxBackground = Colors.transparent;
    Color textColor = black_text;

    if (carTimetable.getStatus() == DateEntryStatus.Booked) {
      boxBackground = red;
      textColor = Colors.white;
    }

    return Container(
      width: 100,
      height: 20,
      child: Container(
        child: new FlatButton(
          color: boxBackground,
          onPressed: () => {},
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
    );
  }
}
