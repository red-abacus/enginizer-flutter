import 'dart:ui';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/requests/order-issue-item-request.model.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/widgets/cards/issue-item-order.card.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimateOrderModal extends StatefulWidget {
  final int workEstimateId;

  WorkEstimateOrderModal({this.workEstimateId});

  @override
  _WorkEstimateOrderModalState createState() => _WorkEstimateOrderModalState();
}

class _WorkEstimateOrderModalState extends State<WorkEstimateOrderModal> {
  bool _initDone = false;
  bool _isLoading = false;

  WorkEstimateProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: FractionallySizedBox(
            heightFactor: .8,
            child: Container(
                child: ClipRRect(
              borderRadius: new BorderRadius.circular(5.0),
              child: Container(
                decoration: new BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))),
                child: Theme(
                  data: ThemeData(
                      accentColor: Theme.of(context).primaryColor,
                      primaryColor: Theme.of(context).primaryColor),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _contentWidget(),
                ),
              ),
            ))));
  }

  _contentWidget() {
    return _provider.itemsToOrder.length == 0
        ? Center(
            child: Text(
            S.of(context).estimator_no_items_to_order,
            style: TextHelper.customTextStyle(null, gray3, FontWeight.bold, 16),
          ))
        : Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _provider.itemsToOrder.length,
                  itemBuilder: (context, index) {
                    return IssueItemOrder(
                        issueItem: _provider.itemsToOrder[index],
                        selectIssueItem: _selectIssueItem,
                        selected: _provider.selectedItemsToOrder
                            .contains(_provider.itemsToOrder[index]));
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      _order();
                    },
                    child: Text(
                      S.of(context).general_order,
                      style: TextHelper.customTextStyle(
                          null, red, FontWeight.bold, 16),
                    ),
                  ),
                ),
              )
            ],
          );
  }

  @override
  void didChangeDependencies() {
    if (!_initDone) {
      _provider = Provider.of<WorkEstimateProvider>(context);
      _loadData();
    }

    super.didChangeDependencies();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _provider
          .getAppointmentIssues(_provider.selectedAppointmentDetail.id)
          .then((_) async {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(AppointmentsService.APPOINTMENT_ITEMS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_appointment_items, context);
      }

      setState(() {
        _isLoading = false;
      });
    }

    _initDone = true;
  }

  _selectIssueItem(IssueItem issueItem) {
    setState(() {
      if (_provider.selectedItemsToOrder.contains(issueItem)) {
        _provider.selectedItemsToOrder.remove(issueItem);
      } else {
        _provider.selectedItemsToOrder.add(issueItem);
      }
    });
  }

  _order() async {
    if (_provider.selectedItemsToOrder.length == 0) {
      AlertWarningDialog.showAlertDialog(context, S.of(context).general_warning,
          S.of(context).estimator_order_warning_title);
    } else {
      setState(() {
        _isLoading = true;
      });

      OrderIssueItemRequest request =
          OrderIssueItemRequest(items: _provider.selectedItemsToOrder);

      try {
        await _provider
            .orderAppointmentItems(
                _provider.selectedAppointmentDetail.id, request)
            .then((value) {
              if (value != null) {
                _provider.initDone = false;
                Navigator.pop(context);
              }
        });
      } catch (error) {
        if (error
            .toString()
            .contains(AppointmentsService.ORDER_APPOINTMENT_ITEMS_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_order_appointment_items, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
