import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/screens/appointment-details.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/appointment-create-modal.widget.dart';
import 'package:app/modules/appointments/widgets/appointments-list.widget.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/mechanic-appointments/enums/appointment-type.enum.dart';
import 'package:app/modules/orders/providers/order.provider.dart';
import 'package:app/modules/orders/services/order.service.dart';
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

  OrderProvider _provider;

  _OrdersState({this.route});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, ordersProvider, _) => Scaffold(
        body: Center(
          child: Container()
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<OrderProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
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
      _provider.resetParameters();
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
    Provider.of<AppointmentProvider>(context)
        .selectAppointment(selectedAppointment);
    Navigator.of(context).pushNamed(AppointmentDetails.route);
  }

  _filterAppointments(
      String string, AppointmentStatusState state, DateTime dateTime) {
    Provider.of<AppointmentsProvider>(context)
        .filterAppointments(string, state, dateTime);
  }

  _renderAppointments(bool _isLoading, List<Appointment> appointments) {
    AppointmentsProvider provider = Provider.of<AppointmentsProvider>(context);

    return _isLoading
        ? CircularProgressIndicator()
        : AppointmentsList(
            appointments: appointments,
            selectAppointment: _selectAppointment,
            filterAppointments: _filterAppointments,
            searchString: provider.filterSearchString,
            appointmentStatusState: provider.filterStatus,
            filterDateTime: provider.filterDateTime,
            appointmentType: AppointmentType.CLIENT,
          );
  }

  void _openAppointmentCreateModal(BuildContext buildContext) {
    Provider.of<ProviderServiceProvider>(context).initFormValues();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AppointmentCreateModal(
              _createAppointment,
              true,
            );
          });
        });
  }

  _createAppointment(AppointmentRequest appointmentRequest) async {
    try {
      await Provider.of<AppointmentsProvider>(context)
          .createAppointment(appointmentRequest)
          .then((_) {
        Navigator.pop(context);
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.CREATE_APPOINTMENT_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_create_appointment, context);
      }
    }
  }
}
