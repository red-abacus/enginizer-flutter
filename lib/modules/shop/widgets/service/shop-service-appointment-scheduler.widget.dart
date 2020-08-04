import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/widgets/personnel/scheduler.widget.dart';
import 'package:app/modules/shop/providers/shop-appointment.provider.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopServiceAppointmentSchedulerWidget extends StatefulWidget {
  @override
  _ShopServiceAppointmentSchedulerWidgetState createState() =>
      _ShopServiceAppointmentSchedulerWidgetState();
}

class _ShopServiceAppointmentSchedulerWidgetState
    extends State<ShopServiceAppointmentSchedulerWidget> {
  bool _initDone = false;
  bool _isLoading = false;

  ShopAppointmentProvider _provider;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator()),
          )
        : _getContent();
  }

  _getContent() {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          SchedulerWidget(
            calendarEntries: CalendarEntry.getDateEntries(_provider.timetables),
            dateEntrySelected: _dateEntrySelected,
            dateEntry: _provider.dateEntry,
            disableSelect: false,
            shouldScroll: false,
          )
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<ShopAppointmentProvider>(context);

      _loadData();

      _initDone = true;
    }
    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    String startDate = DateUtils.stringFromDate(DateTime.now(), "dd/MM/yyyy");
    String endDate = DateUtils.stringFromDate(
        DateUtils.addDayToDate(DateTime.now(), 7), "dd/MM/yyyy");

    try {
      await _provider
          .loadServiceProviderTimetables(1, startDate, endDate)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_TIMETABLE_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_provider_timetable, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _dateEntrySelected(DateEntry dateEntry) {
    setState(() {
      _provider.dateEntry = dateEntry;
    });
  }
}
