import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/scheduler.widget.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimateDateWidget extends StatefulWidget {
  @override
  WorkEstimateDateWidgetState createState() =>
      WorkEstimateDateWidgetState();
}

class WorkEstimateDateWidgetState
    extends State<WorkEstimateDateWidget> {
  @override
  Widget build(BuildContext context) {
    WorkEstimateProvider provider =
        Provider.of<WorkEstimateProvider>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * .7,
      child: SchedulerWidget(
        // TODO - for now, this feature will be on next versions of app.
        //        calendarEntries: CalendarEntry.getDateEntries(DateTime.now(), widget.appointments),
        calendarEntries: CalendarEntry.getDateEntriesFromTimetable(
            DateTime.now(), [], provider.serviceProviderTimetable),
        dateEntrySelected: _dateEntrySelected,
        dateEntry: provider.workEstimateRequest.dateEntry,
      ),
    );
  }

  _dateEntrySelected(DateEntry dateEntry) {
    setState(() {
      Provider.of<WorkEstimateProvider>(context)
          .workEstimateRequest
          .dateEntry = dateEntry;
    });
  }
}
