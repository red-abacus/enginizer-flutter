import 'package:app/config/injection.dart';
import 'package:app/modules/invoices/enums/invoice-sort.enum.dart';
import 'package:app/modules/invoices/models/invoice.model.dart';
import 'package:app/modules/invoices/models/requests/invoices-request.model.dart';
import 'package:app/modules/invoices/models/responses/invoices-response.model.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:flutter/cupertino.dart';

class InvoicesProvider with ChangeNotifier {
  WorkEstimatesService _workEstimatesService = inject<WorkEstimatesService>();

  InvoicesResponse invoicesResponse;
  InvoicesRequest invoicesRequest;
  List<Invoice> invoices = [];

  bool initDone = false;

  initialise() {
    invoicesRequest = new InvoicesRequest();
    invoices = [];
  }

  bool shouldDownload() {
    if (invoicesResponse != null) {
      if (invoicesRequest.currentPage >= invoicesResponse.totalPages) {
        return false;
      }
    }

    return true;
  }

  Future<List<Invoice>> loadInvoices(InvoicesRequest invoicesRequest) async {
    if (!shouldDownload()) {
      return null;
    }

    try {
      this.invoicesResponse =
          await this._workEstimatesService.getInvoices(invoicesRequest);
      this.invoices.addAll(this.invoicesResponse.items);
      invoicesRequest.currentPage += 1;
      notifyListeners();
      return this.invoices;
    } catch (error) {
      throw (error);
    }
  }

  filterInvoices(
      String searchString, InvoiceSort invoiceSort, DateTime startDate, DateTime endDate) {
    invoicesResponse = null;
    invoices = [];
    invoicesRequest = InvoicesRequest();
    invoicesRequest.searchString = searchString;
    invoicesRequest.invoiceSort = invoiceSort;
    invoicesRequest.startDate = startDate;
    invoicesRequest.endDate = endDate;
  }
}
