import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/providers/provider-service.provider.dart';
import 'package:enginizer_flutter/modules/appointments/widgets/scheduler.widget.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AppointmentDateTimeForm extends StatefulWidget {
  List<Appointment> appointments;

  AppointmentDateTimeForm({Key key, this.appointments}) : super(key: key);

  @override
  AppointmentDateTimeFormState createState() => AppointmentDateTimeFormState();
}

class AppointmentDateTimeFormState extends State<AppointmentDateTimeForm> {
  ProviderServiceProvider providerServiceProvider;

  @override
  Widget build(BuildContext context) {
    providerServiceProvider = Provider.of<ProviderServiceProvider>(context);

    return SchedulerWidget(
      calendarEntries:
          CalendarEntry.getDateEntries(DateTime.now(), widget.appointments),
    );
  }

  bool valid() {
    return true;
  }
}
