import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/providers/create-work-estimate.provider.dart';
import 'package:enginizer_flutter/modules/shared/widgets/datetimepicker.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateWorkEstimateDateWidget extends StatefulWidget {
  @override
  CreateWorkEstimateDateWidgetState createState() =>
      CreateWorkEstimateDateWidgetState();
}

class CreateWorkEstimateDateWidgetState
    extends State<CreateWorkEstimateDateWidget> {
  @override
  Widget build(BuildContext context) {
    CreateWorkEstimateProvider provider = Provider.of<CreateWorkEstimateProvider>(context);

    return Container(
      child: BasicDateTimePicker(
        labelText: S.of(context).auction_proposed_date,
        validator: (value) {
          if (value == null) {
            return S.of(context).auction_proposed_date_error;
          } else {
            return null;
          }
        },
        onChange: (value) {
          setState(() {
            provider.proposedDate = value;
          });
        },
        dateTime: provider.proposedDate,
      ),
    );
  }
}
