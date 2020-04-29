import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';

class AssignEmployeeRequest {
  int providerId;
  int appointmentId;
  int employeeId;

  EmployeeTimeSerie timeSerie;

  Map<String, dynamic> toJson() => {
        'appointmentId': appointmentId,
        'localDate': timeSerie.date,
        'timeSeries': [
          {'hour': timeSerie.hour, 'slotStatus': 'BOOKED'}
        ]
      };
}
