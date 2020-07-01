import 'package:app/modules/invoices/enums/invoice-sort.enum.dart';
import 'package:app/utils/date_utils.dart';

class InvoicesRequest {
  String searchString;
  int pageSize = 20;
  int currentPage = 0;
  InvoiceSort invoiceSort;
  DateTime startDate;
  DateTime endDate;

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

    if (startDate != null) {
      propMap['startDate'] = DateUtils.stringFromDate(startDate, 'dd/MM/yyyy');
    }

    if (endDate != null) {
      propMap['endDate'] = DateUtils.stringFromDate(endDate, 'dd/MM/yyyy');
    }

    propMap['isSortingAscending'] = false;

    return propMap;
  }
}
