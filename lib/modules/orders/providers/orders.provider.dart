import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointments-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/orders/services/order.service.dart';
import 'package:flutter/cupertino.dart';

class OrdersProvider with ChangeNotifier {
  OrderService _orderService = inject<OrderService>();

  List<Appointment> appointments = [];

  bool initDone = false;

  AppointmentsResponse _appointmentsResponse;
  AppointmentsRequest appointmentsRequest;

  void resetParameters() {
    initDone = false;

    _appointmentsResponse = null;

    appointments = [];
    appointmentsRequest = null;
    appointmentsRequest = AppointmentsRequest();
  }

  Future<List<Appointment>> getOrders() async {
    if (!shouldDownload()) {
      return null;
    }

    try {
      this._appointmentsResponse =
          await this._orderService.getOrders(appointmentsRequest);
      this.appointments.addAll(this._appointmentsResponse.items);
      appointmentsRequest.currentPage += 1;
      notifyListeners();
      return appointments;
    } catch (error) {
      throw (error);
    }
  }

  bool shouldDownload() {
    if (_appointmentsResponse != null) {
      if (appointmentsRequest.currentPage >= _appointmentsResponse.totalPages) {
        return false;
      }
    }

    return true;
  }

  filterAppointments(String searchString,
      AppointmentStatusState filterStatus, DateTime dateTime) async {
    _appointmentsResponse = null;
    appointments = [];
    appointmentsRequest = AppointmentsRequest();

    appointmentsRequest.searchString = searchString;
    appointmentsRequest.state = filterStatus;
    appointmentsRequest.dateTime = dateTime;
  }
}
