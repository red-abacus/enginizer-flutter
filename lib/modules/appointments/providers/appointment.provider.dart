import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/consultant-estimators/models/work-estimate.model.dart';
import 'package:flutter/cupertino.dart';

class AppointmentProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  WorkEstimatesService _workEstimatesService = inject<WorkEstimatesService>();

  Appointment _selectedAppointment;
  AppointmentDetail _selectedAppointmentDetail;

  Appointment get selectedAppointment {
    return _selectedAppointment;
  }

  AppointmentDetail get selectedAppointmentDetail {
    return _selectedAppointmentDetail;
  }

  selectAppointment(Appointment appointment) {
    this._selectedAppointment = appointment;
  }

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    try {
      _selectedAppointmentDetail =
          await this.appointmentsService.getAppointmentDetails(appointment.id);
      notifyListeners();
      return _selectedAppointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  Future<Appointment> cancelAppointment(Appointment appointment) async {
    try {
      _selectedAppointment =
          await this.appointmentsService.cancelAppointment(appointment.id);
      notifyListeners();
      return _selectedAppointment;
    } catch (error) {
      throw (error);
    }
  }

  Future<WorkEstimate> acceptWorkEstimate(
      int workEstimateId, String proposedDate) async {
    try {
      WorkEstimate workEstimate = await _workEstimatesService.acceptWorkEstimate(
          workEstimateId, proposedDate);
      notifyListeners();
      return workEstimate;
    }
    catch (error) {
      throw(error);
    }
  }
}
