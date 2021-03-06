import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/orders/providers/order.provider.dart';
import 'package:app/modules/orders/providers/orders.provider.dart';
import 'package:app/modules/orders/screens/order.dart';
import 'package:app/modules/orders/services/order.service.dart';
import 'package:app/modules/orders/widgets/orders-list.widget.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  static const String route = '/orders';
  static final IconData icon = Icons.assignment;

  @override
  State<StatefulWidget> createState() {
    return _OrdersState(route: route);
  }
}

class _OrdersState extends State<Orders> {
  String route;

  var _isLoading = false;
  var _initDone = false;

  OrdersProvider _provider;

  _OrdersState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, ordersProvider, _) => Scaffold(
        body: _renderAppointments(_isLoading, ordersProvider.appointments),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<OrdersProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      _provider.resetParameters();
      setState(() {
        _isLoading = true;
      });

      _loadData();
    }

    _initDone = true;
    _provider.initDone = true;

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.getOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(OrderService.GET_ORDERS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_orders, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _selectAppointment(BuildContext ctx, Appointment selectedAppointment) {
    Provider.of<OrderProvider>(context).resetParameters();
    Provider.of<OrderProvider>(context).order = selectedAppointment;
    Navigator.of(context).pushNamed(OrderDetails.route);
  }

  _filterAppointments(
      String string, AppointmentStatusState state, DateTime dateTime) {
    _provider.filterAppointments(string, state, dateTime);
    _loadData();
  }

  _renderAppointments(bool _isLoading, List<Appointment> appointments) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : OrdersList(
            appointments: appointments,
            selectAppointment: _selectAppointment,
            filterAppointments: _filterAppointments,
            searchString: _provider.appointmentsRequest.searchString,
            appointmentStatusState: _provider.appointmentsRequest.state,
            filterDateTime: _provider.appointmentsRequest.dateTime,
            downloadNextPage: _loadData,
            shouldDownload: _provider.shouldDownload(),
          );
  }
}
