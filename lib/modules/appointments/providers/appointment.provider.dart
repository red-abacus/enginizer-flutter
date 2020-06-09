import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/models/auction-map.model.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';

class AppointmentProvider with ChangeNotifier {
  AppointmentsService _appointmentsService = inject<AppointmentsService>();
  BidsService _bidsService = inject<BidsService>();
  AuctionsService _auctionsService = inject<AuctionsService>();

  bool initDone = false;

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetail;

  AuctionMapDirections auctionMapDirections;

  initialiseParams() {
    initDone = false;
    selectedAppointment = null;
    selectedAppointmentDetail = null;
    auctionMapDirections = null;
  }

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    try {
      selectedAppointmentDetail =
          await this._appointmentsService.getAppointmentDetails(appointment.id);
      notifyListeners();
      return selectedAppointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  Future<Appointment> cancelAppointment(Appointment appointment) async {
    try {
      selectedAppointment =
          await this._appointmentsService.cancelAppointment(appointment.id);
      notifyListeners();
      return selectedAppointment;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> cancelBid(int bidId) async {
    try {
      bool response = await this._bidsService.rejectBid(bidId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> acceptBid(int bidId) async {
    try {
      bool response = await this._bidsService.acceptBid(bidId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> loadMapData(BuildContext context) async {
    auctionMapDirections = AuctionMapDirections(
        destinationPoints:
            selectedAppointmentDetail.appointmentTransportInfo.getLocations());
    auctionMapDirections.appointmentDate = DateUtils.dateFromString(selectedAppointmentDetail.scheduledDate, 'dd/MM/yyyy HH:mm');

    try {
      await auctionMapDirections.setPolyLines(context);
      await auctionMapDirections.fetchDistanceAndDurations(_auctionsService);
    } catch (error) {
      throw (error);
    }
  }
}
