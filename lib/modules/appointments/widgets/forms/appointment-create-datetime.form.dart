import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/snack_bar.helper.dart';
import 'package:flutter/material.dart';
import 'package:app/modules/appointments/widgets/scheduler.widget.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AppointmentDateTimeForm extends StatefulWidget {
  List<ServiceProviderSchedule> providerSchedules;
  GlobalKey<ScaffoldState> scaffoldKey;

  AppointmentDateTimeForm({Key key, this.providerSchedules, this.scaffoldKey})
      : super(key: key);

  @override
  AppointmentDateTimeFormState createState() => AppointmentDateTimeFormState();
}

class AppointmentDateTimeFormState extends State<AppointmentDateTimeForm> {
  bool _initDone = false;
  bool _isLoading = false;

  ProviderServiceProvider _providerServiceProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _getContent());
  }

  _getContent() {
    return SchedulerWidget(
        // TODO - for now, this feature will be on next versions of app.
        //        calendarEntries: CalendarEntry.getDateEntries(DateTime.now(), widget.appointments),
        calendarEntries: CalendarEntry.getDateEntries(
            DateTime.now(), [], _providerServiceProvider.selectedProvider),
        dateEntrySelected: _dateEntrySelected,
        dateEntry: Provider.of<ProviderServiceProvider>(context).dateEntry,
        disableSelect: false);
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _providerServiceProvider = Provider.of<ProviderServiceProvider>(context);

      if (_providerServiceProvider.selectedProvider != null) {
        _loadData();
      } else {
        setState(() {
          _isLoading = true;
        });
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
      await _providerServiceProvider
          .loadServiceProviderTimetables(
              _providerServiceProvider.selectedProvider, startDate, endDate)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.GET_PROVIDER_TIMETABLE_EXCEPTION)) {
        SnackBarManager.showSnackBar(
            S.of(context).general_error,
            S.of(context).exception_get_provider_timetable,
            widget.scaffoldKey.currentState);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _dateEntrySelected(DateEntry dateEntry) {
    setState(() {
      Provider.of<ProviderServiceProvider>(context).dateEntry = dateEntry;
    });
  }

  bool valid() {
    return true;
  }
}
