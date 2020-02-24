import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ServiceProviderFiscalInfoWidget extends StatefulWidget {
  @override
  ServiceProviderFiscalInfoWidgetState createState() {
    return ServiceProviderFiscalInfoWidgetState();
  }
}

class ServiceProviderFiscalInfoWidgetState
    extends State<ServiceProviderFiscalInfoWidget> {
  @override
  Widget build(BuildContext context) {
    ServiceProviderDetailsProvider provider =
        Provider.of<ServiceProviderDetailsProvider>(context);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _infoText(provider.serviceProvider.fiscalName),
            _infoText(provider.serviceProvider.address),
            _infoText(provider.serviceProvider.cui),
            _infoText(provider.serviceProvider.registrationNumber),
            _vtaText(provider.serviceProvider.isVATPayer),
          ],
        ),
      ),
    );
  }

  _infoText(String title) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        title,
        style: TextHelper.customTextStyle(null, gray2, FontWeight.bold, 16),
      ),
    );
  }

  _vtaText(bool isVTAPayer) {
    String payer = isVTAPayer ? S.of(context).general_yes : S.of(context).general_no;

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        '${S.of(context).appointment_details_service_vta_payer}: $payer',
        style: TextHelper.customTextStyle(
            null, gray2, FontWeight.bold, 16),
      ),
    );
  }
}
