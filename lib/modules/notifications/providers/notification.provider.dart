import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointments-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/models/bid-details.model.dart';
import 'package:app/modules/auctions/models/request/auction-request.model.dart';
import 'package:app/modules/auctions/models/response/auction-response.model.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:app/modules/notifications/models/app-notification-response.model.dart';
import 'package:app/modules/notifications/models/app-notification.model.dart';
import 'package:app/modules/notifications/services/notification.service.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  NotificationService _notificationService = inject<NotificationService>();
  AppointmentsService _appointmentsService = inject<AppointmentsService>();
  AuctionsService _auctionService = inject<AuctionsService>();
  BidsService _bidsService = inject<BidsService>();

  List<AppNotification> notifications = [];

  AppNotificationResponse notificationResponse;

  int _notificationsPage = 0;
  int _pageSize = 20;

  initialiseParams() {
    _notificationsPage = 0;
    notificationResponse = null;
    notifications = [];
  }

  Future<AppNotificationResponse> loadNotifications() async {
    if (notificationResponse != null) {
      if (_notificationsPage >= notificationResponse.totalPages) {
        return null;
      }
    }

    try {
      notificationResponse = await _notificationService.getNotifications(_notificationsPage,
          pageSize: _pageSize);
      this.notifications.addAll(notificationResponse.notifications);
      _notificationsPage += 1;
      return notificationResponse;
    } catch (error) {
      throw (error);
    }
  }
  
  Future<Appointment> getAppointment(int appointmentId) async {
    AppointmentsRequest request = new AppointmentsRequest();
    request.ids = [appointmentId.toString()];

    try {
      AppointmentsResponse appointmentsResponse = await _appointmentsService.getAppointments(request);
      notifyListeners();

      if (appointmentsResponse.items.length > 0) {
        return appointmentsResponse.items[0];
      }
      else {
        return null;
      }
    }
    catch (error) {
      throw(error);
    }
  }

  Future<Auction> getAuction(int auctionId) async {
    AuctionRequest request = new AuctionRequest();
    request.ids = [auctionId.toString()];

    try {
      AuctionResponse auctionResponse = await _auctionService.getAuctions(request);
      notifyListeners();

      if (auctionResponse.auctions.length > 0) {
        return auctionResponse.auctions[0];
      }
      else {
        return null;
      }
    }
    catch (error) {
      throw(error);
    }
  }

  Future<BidDetails> getBidDetails(int bidId) async {
    try {
      BidDetails bidDetails = await this._bidsService.getBidDetails(bidId);
      notifyListeners();
      return bidDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> markAsSeen(List<String> ids) async {
    try {
      final bool response = await _notificationService.markAsSeen(ids);
      notifyListeners();
      return response;
    }
    catch (error) {
      throw(error);
    }
  }
}
