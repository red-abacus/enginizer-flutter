import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/auctions/widgets/details-consultant/car-details-parts.widget.dart';
import 'package:app/modules/orders/providers/order.provider.dart';
import 'package:app/modules/orders/screens/orders.dart';
import 'package:app/modules/orders/services/order.service.dart';
import 'package:app/modules/orders/widgets/order-delivery-parts.widget.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  static const String route = '${Orders.route}/orderDetails';

  @override
  State<StatefulWidget> createState() {
    return OrderDetailsState(route: route);
  }
}

class OrderDetailsState extends State<OrderDetails>
    with SingleTickerProviderStateMixin {
  String route;

  bool _initDone = false;
  bool _isLoading = false;

  OrderDetailsState({this.route});

  OrderProvider _provider;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_provider != null && _provider.appointment == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).cardColor),
              title: _titleText(),
            ),
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).cardColor),
              bottom: TabBar(
                controller: _tabController,
                tabs: _getTabs(),
              ),
              title: _titleText(),
            ),
            body: _buildContent(),
          );
  }

  _getTabs() {
    List<Tab> tabs = [
      Tab(text: S.of(context).appointment_details_car_details),
      Tab(text: S.of(context).parts_delivery_title),
    ];
    return tabs;
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<OrderProvider>(context);

      setState(() {
        _isLoading = true;
      });

      _loadData();
      _initDone = true;
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    try {
      await _provider.getOrderDetails(_provider.appointment).then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(OrderService.GET_ORDER_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_order_details, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _titleText() {
    return Text(
      _provider.appointment?.name ?? 'N/A',
      style:
          TextHelper.customTextStyle(null, Colors.white, FontWeight.bold, 20),
    );
  }

  _buildContent() {
    List<Widget> list = [
      CarDetailsPartsWidget(car: _provider.appointment.car),
      OrderDeliveryParts(
          showProviderDetails: _showProviderDetails, acceptOrder: _acceptOrder)
    ];

    return TabBarView(
      controller: _tabController,
      children: list,
    );
  }

  _showProviderDetails() {
    Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId =
        _provider.appointmentDetail.serviceProvider.id;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return ServiceDetailsModal();
          });
        });
  }

  _acceptOrder(DateTime dateTime) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .acceptOrder(_provider.appointment.id,
              DateUtils.stringFromDate(dateTime, 'dd/MM/yyyy HH:mm'))
          .then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error.toString().contains(OrderService.ACCEPT_ORDER_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_accept_order, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
