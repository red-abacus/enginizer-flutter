import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/handover/procedure-info.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/orders/screens/order.dart';
import 'package:app/modules/orders/services/order.service.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  OrderService _orderService = inject<OrderService>();
  AppointmentsService _appointmentsService = inject<AppointmentsService>();

  AppointmentDetail orderDetails;
  Appointment order;

  AppointmentDetail appointmentDetails;

  void resetParameters() {
    order = null;
    orderDetails = null;
    appointmentDetails = null;
  }

  Future<AppointmentDetail> getAppointmentDetails(int appointmentId) async {
    try {
      appointmentDetails =
          await _appointmentsService.getAppointmentDetails(appointmentId);
      notifyListeners();
      return orderDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> getOrderDetails(Appointment appointment) async {
    try {
      orderDetails = await _orderService.getOrderDetails(appointment.id);
      notifyListeners();
      return orderDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> acceptOrder(
      int orderId, String deliveryDate) async {
    try {
      orderDetails = await _orderService.acceptOrder(orderId, deliveryDate);
      notifyListeners();
      return orderDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> finishOrder(int orderId) async {
    try {
      orderDetails = await _orderService.finishOrder(orderId);
      notifyListeners();
      return orderDetails;
    } catch (error) {
      throw (error);
    }
  }
}
