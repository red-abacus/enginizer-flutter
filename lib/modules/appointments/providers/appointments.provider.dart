import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/request/appointment-request.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/appointments.service.dart';
import 'package:flutter/widgets.dart';

class AppointmentsProvider with ChangeNotifier {
  List<Appointment> _appointments = [];
  List<ServiceItem> _serviceItems = [];

  Map<String, dynamic> serviceFormState = {'id': null, 'name': null};

  AppointmentsService appointmentsService = inject<AppointmentsService>();

  List<Appointment> get appointments {
    return _appointments;
  }

  void refreshAppointment(Appointment appointment) {
    for (int i = 0; i < _appointments.length; i++) {
      if (_appointments[i].id == appointment.id) {
        _appointments[i] = appointment;
//        notifyListeners();
        break;
      }
    }
  }

  Future<List<Appointment>> loadAppointments() async {
    var response = await this.appointmentsService.getAppointments();
    _appointments = response.items;

    notifyListeners();
    return _appointments;
  }

  Future<Appointment> createAppointment(AppointmentRequest appointmentRequest) async {
    var newAppointment =
        await this.appointmentsService.createAppointment(appointmentRequest);
    _appointments.add(newAppointment);
    notifyListeners();
    return newAppointment;
  }
}
