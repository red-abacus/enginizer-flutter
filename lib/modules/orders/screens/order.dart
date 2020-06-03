import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/widgets/details/appointment-details-generic-consultant.widget.dart';
import 'package:app/modules/appointments/widgets/service-details-modal.widget.dart';
import 'package:app/modules/auctions/widgets/details-consultant/car-details-parts.widget.dart';
import 'package:app/modules/orders/providers/order.provider.dart';
import 'package:app/modules/orders/providers/orders.provider.dart';
import 'package:app/modules/orders/screens/orders.dart';
import 'package:app/modules/orders/services/order.service.dart';
import 'package:app/modules/orders/widgets/order-confirm-parts.widget.dart';
import 'package:app/modules/orders/widgets/order-delivery-parts.widget.dart';
import 'package:app/modules/shared/managers/permissions/permissions-manager.dart';
import 'package:app/modules/shared/managers/permissions/permissions-order.dart';
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

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Orders, PermissionsOrder.CREATE_ORDER)) {
      _tabController =
          new TabController(vsync: this, length: 2, initialIndex: 1);
    } else if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Orders, PermissionsOrder.VIEW_ORDER)) {
      _tabController =
          new TabController(vsync: this, length: 3, initialIndex: 2);
    } else {
      new TabController(vsync: this, length: 0, initialIndex: 0);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_provider != null && _provider.order == null) {
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
    List<Tab> tabs = [];

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Orders, PermissionsOrder.CREATE_ORDER)) {
      tabs = [
        Tab(text: S.of(context).appointment_details_car_details),
        Tab(text: S.of(context).parts_delivery_title),
      ];
    } else if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Orders, PermissionsOrder.VIEW_ORDER)) {
      tabs = [
        Tab(text: S.of(context).appointment_details_request),
        Tab(text: S.of(context).appointment_details_car),
        Tab(text: S.of(context).appointment_consultant_final_estimate_title)
      ];
    }

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
      await _provider.getOrderDetails(_provider.order).then((_) async {
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
      _provider.order?.name ?? 'N/A',
      style:
          TextHelper.customTextStyle(null, Colors.white, FontWeight.bold, 20),
    );
  }

  _buildContent() {
    List<Widget> list = [];

    if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Orders, PermissionsOrder.CREATE_ORDER)) {
      list = [
        CarDetailsPartsWidget(car: _provider.order.car),
        OrderDeliveryParts(
            showProviderDetails: _showProviderDetails,
            acceptOrder: _acceptOrder)
      ];
    } else if (PermissionsManager.getInstance()
        .hasAccess(MainPermissions.Orders, PermissionsOrder.VIEW_ORDER)) {
      list = [
        AppointmentDetailsGenericConsultantWidget(
          appointmentDetail: _provider.orderDetails,
        ),
        OrderConfirmParts(
            showProviderDetails: _showProviderDetails,
            acceptOrder: _acceptOrder)
      ];
    }

    return TabBarView(
      controller: _tabController,
      children: list,
    );
  }

  _showProviderDetails() {
    if (_provider.orderDetails.buyer != null) {
      Provider.of<ServiceProviderDetailsProvider>(context).serviceProviderId =
          _provider.orderDetails.buyer.id;

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
  }

  _acceptOrder(DateTime dateTime) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .acceptOrder(_provider.order.id,
              DateUtils.stringFromDate(dateTime, 'dd/MM/yyyy HH:mm'))
          .then((_) async {
        Provider.of<OrdersProvider>(context).initDone = false;
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
