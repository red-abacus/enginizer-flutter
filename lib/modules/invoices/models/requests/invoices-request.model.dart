import 'package:app/modules/invoices/enums/invoice-sort.enum.dart';
import 'package:app/modules/invoices/enums/invoice-type.enum.dart';

class InvoicesRequest {
  String searchString;
  int pageSize = 20;
  int currentPage = 0;
  InvoiceSort invoiceSort;
  InvoiceType invoiceType;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'pageSize': pageSize.toString(),
      'page': currentPage.toString()
    };

    if (searchString != null && searchString.isNotEmpty) {
      propMap['search'] = searchString;
    }

    if (invoiceSort != null) {
      propMap['sortBy'] = InvoiceSortUtils.value(this.invoiceSort);
    }

    if (invoiceType != null) {
      propMap['type'] = InvoiceTypeUtils.value(this.invoiceType);
    }

    propMap['isSortingAscending'] = false;

    return propMap;
  }
}
