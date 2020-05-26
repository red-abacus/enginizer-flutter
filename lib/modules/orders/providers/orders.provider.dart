import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/response/appointments-response.model.dart';
import 'package:app/modules/orders/services/order.service.dart';
import 'package:flutter/cupertino.dart';

class OrdersProvider with ChangeNotifier {
  OrderService _orderService = inject<OrderService>();

  List<Appointment> appointments = [];

  bool initDone = false;
  AppointmentsResponse _appointmentsResponse;

  int _orderPage = 0;
  final int _pageSize = 20;

  String searchString;

  void resetParameters() {
    _appointmentsResponse = null;
    initDone = false;
    _orderPage = 0;
//    this.filterStatus = null;
    this.searchString = null;

    appointments = [];
  }

  Future<AppointmentsResponse> getOrders() async {
    if (_appointmentsResponse != null) {
      if (_orderPage >= _appointmentsResponse.totalPages) {
        return null;
      }
    }

    try {
      _appointmentsResponse = await _orderService.getOrders(_orderPage,
          pageSize: _pageSize,
          searchString: this.searchString);
      this.appointments.addAll(_appointmentsResponse.items);
      _orderPage += 1;
      return _appointmentsResponse;
    } catch (error) {
      throw (error);
    }
  }
}
