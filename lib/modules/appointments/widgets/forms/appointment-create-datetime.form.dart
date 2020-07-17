import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/material.dart';
import 'package:app/modules/appointments/widgets/personnel/scheduler.widget.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AppointmentDateTimeForm extends StatefulWidget {
  List<ServiceProviderSchedule> providerSchedules;

  AppointmentDateTimeForm({this.providerSchedules});

  @override
  AppointmentDateTimeFormState createState() => AppointmentDateTimeFormState();
}

class AppointmentDateTimeFormState extends State<AppointmentDateTimeForm> {
  bool _initDone = false;
  bool _isLoading = false;

  ProviderServiceProvider _provider;

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
    var entries =
        CalendarEntry.getDateEntries(_provider.serviceProviderTimetable);

    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          entries.length > 0
              ? SchedulerWidget(
                  calendarEntries: entries,
                  dateEntrySelected: _dateEntrySelected,
                  dateEntry:
                      Provider.of<ProviderServiceProvider>(context).dateEntry,
                  disableSelect: false,
                  shouldScroll: false,
                )
              : Container(
                  margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          S
                              .of(context)
                              .appointment_create_no_timetable_available,
                          textAlign: TextAlign.center,
                          style: TextHelper.customTextStyle(
                              size: 16, color: gray3),
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<ProviderServiceProvider>(context);

      if (_provider.selectedProvider != null) {
        _loadData();
      }

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
          .loadServiceProviderTimetables(
              _provider.selectedProvider, startDate, endDate)
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
