import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/scheduler.widget.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/providers/create-work-estimate.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateWorkEstimateDateWidget extends StatefulWidget {
  @override
  CreateWorkEstimateDateWidgetState createState() =>
      CreateWorkEstimateDateWidgetState();
}

class CreateWorkEstimateDateWidgetState
    extends State<CreateWorkEstimateDateWidget> {
  @override
  Widget build(BuildContext context) {
    CreateWorkEstimateProvider provider =
        Provider.of<CreateWorkEstimateProvider>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * .6,
      child: SchedulerWidget(
        // TODO - for now, this feature will be on next versions of app.
        //        calendarEntries: CalendarEntry.getDateEntries(DateTime.now(), widget.appointments),
        calendarEntries: CalendarEntry.getDateEntriesFromTimetable(
            DateTime.now(), [], provider.serviceProviderTimetable),
        dateEntrySelected: _dateEntrySelected,
        dateEntry: provider.dateEntry,
      ),
    );
  }

  _dateEntrySelected(DateEntry dateEntry) {
    setState(() {
      Provider.of<CreateWorkEstimateProvider>(context).dateEntry = dateEntry;
    });
  }
}
