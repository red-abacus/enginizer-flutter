import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/appointments/widgets/scheduler.widget.dart';
import 'package:app/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimateDateWidget extends StatefulWidget {
  final Function estimateDateSelect;
  final EstimatorMode estimatorMode;
  final DateEntry dateEntry;

  WorkEstimateDateWidget({this.estimateDateSelect, this.estimatorMode, this.dateEntry});

  @override
  WorkEstimateDateWidgetState createState() => WorkEstimateDateWidgetState();
}

class WorkEstimateDateWidgetState extends State<WorkEstimateDateWidget> {
  @override
  Widget build(BuildContext context) {
    WorkEstimateProvider provider = Provider.of<WorkEstimateProvider>(context);

    // TODO - date entry is not set for Client when accepts new estimate

    return SizedBox(
      height: MediaQuery.of(context).size.height * .7,
      child: SchedulerWidget(
        // TODO - for now, this feature will be on next versions of app.
        //        calendarEntries: CalendarEntry.getDateEntries(DateTime.now(), widget.appointments),
        calendarEntries: CalendarEntry.getDateEntriesFromTimetable(
            DateTime.now(), [], provider.serviceProviderTimetable),
        dateEntrySelected: _dateEntrySelected,
        dateEntry: widget.dateEntry,
        disableSelect: widget.estimatorMode == EstimatorMode.ReadOnly || widget.estimatorMode == EstimatorMode.Client,
      ),
    );
  }

  _dateEntrySelected(DateEntry dateEntry) {
    widget.estimateDateSelect(dateEntry);
  }
}
