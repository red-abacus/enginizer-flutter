class InvoiceTypeUtils {
  static invoiceType(String sender) {
    switch (sender) {
      case 'INDIVIDUAL':
        return InvoiceType.Individual;
      case 'COMPANY':
        return InvoiceType.Company;
    }

    return null;
  }

  static value(InvoiceType invoiceType) {
    switch (invoiceType) {
      case InvoiceType.Individual:
        return 'INDIVIDUAL';
      case InvoiceType.Company:
        return 'COMPANY';
    }
  }
}

enum InvoiceType { Individual, Company }
