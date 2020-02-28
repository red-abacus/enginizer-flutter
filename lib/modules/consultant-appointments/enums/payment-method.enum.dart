import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class PaymentMethodUtilities {
  static String titleForPaymentMethod(
      BuildContext context, PaymentMethod paymentMethod) {
    switch (paymentMethod) {
      case PaymentMethod.CASH:
        return S.of(context).appointment_consultant_payment_cash;
      case PaymentMethod.TRANSFER:
        return S.of(context).appointment_consultant_payment_transfer;
      case PaymentMethod.CARD:
        return S.of(context).appointment_consultant_payment_card;
    }

    return '';
  }

  static List<PaymentMethod> paymentMethods() {
    return [
      PaymentMethod.CASH,
      PaymentMethod.TRANSFER,
      PaymentMethod.CARD,
    ];
  }
}

enum PaymentMethod { CASH, TRANSFER, CARD }
