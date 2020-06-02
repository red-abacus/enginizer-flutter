import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/enum/appointment-map-state.enum.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/models/auction-map.model.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:flutter/cupertino.dart';

class AppointmentProvider with ChangeNotifier {
  AppointmentsService _appointmentsService = inject<AppointmentsService>();
  BidsService _bidsService = inject<BidsService>();
  AuctionsService _auctionsService = inject<AuctionsService>();

  bool initDone = false;

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetail;

  AuctionMapDirections auctionMapDirections;

  AppointmentMapState appointmentMapState;

  initialiseParams() {
    initDone = false;
    selectedAppointment = null;
    selectedAppointmentDetail = null;
    auctionMapDirections = null;
    appointmentMapState = null;
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

  Future<void> loadAuctionMapData(BuildContext context) async {
    auctionMapDirections = AuctionMapDirections();
    // TODO
//    auctionMapDirections.appointmentDate = DateUtils.dateFromString(auctionDetails.scheduledDateTime, 'dd/MM/yyyy HH:mm:ss');
    auctionMapDirections.appointmentDate = DateTime.now();

    try {
      await auctionMapDirections.setPolyLines(context);
      await auctionMapDirections.fetchDistanceAndDurations(_auctionsService);
    }
    catch (error) {
      throw(error);
    }
  }
}
