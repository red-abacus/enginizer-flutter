import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timeserie.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/scheduler.widget.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AppointmentDateTimeForm extends StatefulWidget {
  List<ServiceProviderSchedule> providerSchedules;

  AppointmentDateTimeForm({Key key, this.providerSchedules})
      : super(key: key);

  @override
  AppointmentDateTimeFormState createState() => AppointmentDateTimeFormState();
}

class AppointmentDateTimeFormState extends State<AppointmentDateTimeForm> {
  bool _initDone = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: SchedulerWidget(
          // TODO - for now, this feature will be on next versions of app.
          //        calendarEntries: CalendarEntry.getDateEntries(DateTime.now(), widget.appointments),
          calendarEntries: CalendarEntry.getDateEntries(DateTime.now(), [],
              Provider.of<ProviderServiceProvider>(context).selectedProvider),
          dateEntrySelected: _dateEntrySelected,
          dateEntry: Provider.of<ProviderServiceProvider>(context).dateEntry,
          disableSelect: false),
    );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      setState(() {});

      ProviderServiceProvider provider =
          Provider.of<ProviderServiceProvider>(context);

      if (provider.selectedProvider != null) {
        String startDate =
            DateUtils.stringFromDate(DateTime.now(), "dd/MM/yyyy");
        String endDate = DateUtils.stringFromDate(
            DateUtils.addDayToDate(DateTime.now(), 7), "dd/MM/yyyy");

        provider
            .loadServiceProviderTimetables(
                provider.selectedProvider, startDate, endDate)
            .then((_) {
          setState(() {});
        });
      } else {
        setState(() {});
      }
    }
    _initDone = true;
    super.didChangeDependencies();
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
