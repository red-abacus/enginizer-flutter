import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/consultant-estimators/models/work-estimate.model.dart';
import 'package:flutter/cupertino.dart';

class AppointmentProvider with ChangeNotifier {
  AppointmentsService appointmentsService = inject<AppointmentsService>();
  BidsService _bidsService = inject<BidsService>();

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

  Future<bool> cancelBid(int bidId) async {
    try {
      bool response = await this._bidsService.rejectBid(bidId);
      notifyListeners();
      return response;
    }
    catch (error) {
      throw(error);
    }
  }

  Future<bool> acceptBid(int bidId) async {
    try {
      bool response = await this._bidsService.acceptBid(bidId);
      notifyListeners();
      return response;
    }
    catch (error) {
      throw(error);
    }
  }
}
