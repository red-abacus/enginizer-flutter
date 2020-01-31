import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/scheduler_widget.dart';
import 'package:flutter/widgets.dart';

class AppointmentDateTimeForm extends StatefulWidget {
  AppointmentDateTimeForm({Key key}) : super(key: key);

  @override
  AppointmentDateTimeFormState createState() => AppointmentDateTimeFormState();
}

class AppointmentDateTimeFormState extends State<AppointmentDateTimeForm> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .5,
      child: SchedulerWidget(
        dateEntries: [
          DateEntry(timeSeries: [
            TimeEntry(time: 'lala', status: TimeEntryStatus.Free)
          ], date: '02/02/2002')
        ],
      ),
    );
  }

  bool valid() {
    return true;
  }
}
