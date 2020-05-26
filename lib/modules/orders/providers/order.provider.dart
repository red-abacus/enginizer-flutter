import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointments-request.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/orders/services/order.service.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  OrderService _orderService = inject<OrderService>();

  AppointmentDetail appointmentDetail;
  Appointment appointment;

  void resetParameters() {
    appointment = null;
    appointmentDetail = null;
  }

  Future<AppointmentDetail> getOrderDetails(
      Appointment appointment) async {
    try {
      appointmentDetail = await _orderService.getOrderDetails(appointment.id);
      notifyListeners();
      return appointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> acceptOrder(
      int orderId, String deliveryDate) async {
    try {
      appointmentDetail = await _orderService.acceptOrder(appointment.id, deliveryDate);
      notifyListeners();
      return appointmentDetail;
    } catch (error) {
      throw (error);
    }
  }
}
