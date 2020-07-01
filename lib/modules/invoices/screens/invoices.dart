import 'package:app/generated/l10n.dart';
import 'package:app/modules/invoices/enums/invoice-sort.enum.dart';
import 'package:app/modules/invoices/models/invoice.model.dart';
import 'package:app/modules/invoices/providers/invoice.provider.dart';
import 'package:app/modules/invoices/providers/invoices.provider.dart';
import 'package:app/modules/invoices/screens/invoice.dart';
import 'package:app/modules/invoices/widgets/invoices-list.widget.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Invoices extends StatefulWidget {
  static const String route = '/invoices';
  static final IconData icon = Icons.description;

  @override
  State<StatefulWidget> createState() {
    return InvoicesState(route: route);
  }
}

class InvoicesState extends State<Invoices> {
  String route;

  var _isLoading = false;
  var _initDone = false;

  InvoicesProvider _provider;

  InvoicesState({this.route});

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<InvoicesProvider>(context);

    return Scaffold(
        body: Center(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : InvoicesList(
              invoices: _provider.invoices,
              filterInvoices: _filterInvoices,
              invoiceSort: _provider.invoicesRequest.invoiceSort,
              searchString: _provider.invoicesRequest.searchString,
              downloadNextPage: _loadData,
              shouldDownload: _provider.shouldDownload(),
              selectInvoice: _selectInvoice,
              startDate: _provider.invoicesRequest.startDate,
              endDate: _provider.invoicesRequest.endDate,
            ),
    ));
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<InvoicesProvider>(context);
    _initDone = _initDone == false ? false : _provider.initDone;

    if (!_initDone) {
      _provider.initialise();
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
      await _provider.loadInvoices(_provider.invoicesRequest).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (error) {
      if (error
          .toString()
          .contains(WorkEstimatesService.GET_INVOICES_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_get_invoices, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  _filterInvoices(String string, InvoiceSort sort, DateTime startDate, DateTime endDate) {
    _provider.filterInvoices(string, sort, startDate, endDate);
    _loadData();
  }

  _selectInvoice(Invoice invoice) {
    Provider.of<InvoiceProvider>(context).initialise();
    Provider.of<InvoiceProvider>(context).invoice = invoice;

    Navigator.of(context).pushNamed(InvoiceDetail.route);
  }
}
