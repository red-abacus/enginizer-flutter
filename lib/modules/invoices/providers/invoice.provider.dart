import 'dart:io';

import 'package:app/config/injection.dart';
import 'package:app/modules/invoices/models/invoice-details.model.dart';
import 'package:app/modules/invoices/models/invoice.model.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:flutter/cupertino.dart';

class InvoiceProvider with ChangeNotifier {
  WorkEstimatesService _workEstimatesService = inject<WorkEstimatesService>();

  Invoice invoice;
  InvoiceDetails invoiceDetails;

  bool initDone = false;

  initialise() {
    invoice = null;
    invoiceDetails = null;
  }

  Future<InvoiceDetails> getInvoiceDetails(int invoiceId) async {
    try {
      invoiceDetails = await _workEstimatesService.getInvoiceDetails(invoiceId);
      notifyListeners();
      return invoiceDetails;
    }
    catch (error) {
      throw(error);
    }
  }

  Future<File> getInvoicePdf(int invoiceId, String path) async {
    try {
      File file = await _workEstimatesService.getInvoicePdf(invoiceId, path);
      notifyListeners();
      return file;
    }
    catch (error) {
      throw(error);
    }
  }
}
