import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-accept-state.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate-accept.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimateAcceptTransportForm extends StatefulWidget {
  final Function refreshState;

  WorkEstimateAcceptTransportForm({this.refreshState});

  @override
  WorkEstimateAcceptTransportFormState createState() {
    return WorkEstimateAcceptTransportFormState();
  }
}

class WorkEstimateAcceptTransportFormState
    extends State<WorkEstimateAcceptTransportForm> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<WorkEstimateAcceptProvider>(context);
//
    return Container(
      padding: EdgeInsets.only(bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CheckboxListTile(
            title: Text(S
                .of(context)
                .estimator_accept_modal_step1_personal_transport),
            onChanged: (bool value) {
              provider.workEstimateAcceptState =
                  WorkEstimateAcceptState.Personal;
              widget.refreshState();
            },
            value: provider.workEstimateAcceptState ==
                WorkEstimateAcceptState.Personal,
          ),
          CheckboxListTile(
            title: Text(
                S.of(context).estimator_accept_modal_step1_pickup_transport),
            onChanged: (bool value) {
              provider.workEstimateAcceptState =
                  WorkEstimateAcceptState.PickUp;
              widget.refreshState();
            },
            value: provider.workEstimateAcceptState ==
                WorkEstimateAcceptState.PickUp,
          ),
        ],
      ),
    );
  }
}
