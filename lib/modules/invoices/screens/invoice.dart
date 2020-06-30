import 'package:app/generated/l10n.dart';
import 'package:app/modules/invoices/providers/invoice.provider.dart';
import 'package:app/modules/invoices/widgets/invoice-details/invoice-details-client.widget.dart';
import 'package:app/modules/invoices/widgets/invoice-details/invoice-details-company.widget.dart';
import 'package:app/modules/invoices/widgets/invoice-details/invoice-details-top.widget.dart';
import 'package:app/modules/invoices/widgets/invoice-details/invoice-details-provider.widget.dart';
import 'package:app/modules/invoices/widgets/invoice-details/invoice-details-work-estimate.widget.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'invoices.dart';

class InvoiceDetail extends StatefulWidget {
  static const String route = '${Invoices.route}/invoiceDetails';

  @override
  State<StatefulWidget> createState() {
    return _InvoiceDetailState(route: route);
  }
}

class _InvoiceDetailState extends State<InvoiceDetail> {
  String route;

  var _isLoading = false;
  var _initDone = false;

  InvoiceProvider _provider;

  _InvoiceDetailState({this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _provider.invoice?.code ?? 'N/A',
            style: TextHelper.customTextStyle(
                color: Colors.white, weight: FontWeight.bold, size: 20),
          ),
          iconTheme: new IconThemeData(color: Theme.of(context).cardColor),
        ),
        floatingActionButton: _floatingButtons(),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _provider.invoiceDetails != null
                ? _contentWidget()
                : Container());
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<InvoiceProvider>(context);
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
      await _provider.getInvoiceDetails(_provider.invoice.id).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(WorkEstimatesService.GET_INVOICE_DETAILS_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_invoice_details, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _contentWidget() {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 80),
        child: Column(
          children: [
            InvoiceDetailsTop(
              invoiceDetails: _provider.invoiceDetails,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: InvoiceDetailsProvider(
                  invoiceDetails: _provider.invoiceDetails),
            ),
            if (_provider.invoiceDetails.client.invoiceIndividualData != null)
              Container(
                margin: EdgeInsets.only(top: 20),
                child: InvoiceDetailsClient(
                    invoiceIndividualData:
                        _provider.invoiceDetails.client.invoiceIndividualData),
              ),
            if (_provider.invoiceDetails.client.invoiceCompany != null)
              Container(
                margin: EdgeInsets.only(top: 20),
                child: InvoiceDetailsCompany(
                    invoiceCompany:
                        _provider.invoiceDetails.client.invoiceCompany),
              ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: InvoiceDetailsWorkEstimate(
                items: _provider.invoiceDetails.items,
              ),
            ),
            _priceContainer(S.of(context).invoice_services_total,
                _provider.invoiceDetails.totalServices()),
            _priceContainer(S.of(context).invoice_product_total,
                _provider.invoiceDetails.totalProducts()),
            _priceContainer(
                S.of(context).estimator_total,
                _provider.invoiceDetails.totalProducts() +
                    _provider.invoiceDetails.totalServices())
          ],
        ),
      ),
    );
  }

  _priceContainer(String title, double value) {
    return Container(
      padding: EdgeInsets.only(bottom: 6),
      decoration: DottedDecoration(
          shape: Shape.line, linePosition: LinePosition.bottom, color: gray_80),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(
            '$title:',
            style: TextHelper.customTextStyle(color: gray2, size: 18),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              value.toStringAsFixed(1),
              style: TextHelper.customTextStyle(
                  color: black_text, size: 18, weight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  _floatingButtons() {
    List<SpeedDialChild> buttons = [
      SpeedDialChild(
          child: Icon(Icons.print),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).invoice_print,
          labelStyle: TextHelper.customTextStyle(
              color: Colors.grey, weight: FontWeight.bold, size: 16),
          onTap: () => _print()),
      SpeedDialChild(
          child: Icon(Icons.save),
          foregroundColor: red,
          backgroundColor: Colors.white,
          label: S.of(context).invoice_save,
          labelStyle: TextHelper.customTextStyle(
              color: Colors.grey, weight: FontWeight.bold, size: 16),
          onTap: () => _save())
    ];

    return SpeedDial(
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      closeManually: false,
      curve: Curves.linear,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: S.of(context).estimator_open_menu,
      heroTag: 'open-menu-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: buttons,
    );
  }

  _print() {}

  _save() {}
}
