import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-accept-state.enum.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate-accept.provider.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
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
          GestureDetector(
            onTap: () {
              provider.workEstimateAcceptState =
                  WorkEstimateAcceptState.Personal;
              widget.refreshState();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    S
                        .of(context)
                        .estimator_accept_modal_step1_personal_transport,
                    style: TextHelper.customTextStyle(null, gray3, null, 16)),
                Icon(
                  provider.workEstimateAcceptState ==
                          WorkEstimateAcceptState.Personal
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: red,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: () {
                provider.workEstimateAcceptState =
                    WorkEstimateAcceptState.PickUp;
                widget.refreshState();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    showDuration: Duration(seconds: 4),
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(20.0),
                    waitDuration: const Duration(milliseconds: 1),
                    message: S.of(context).estimator_accept_modal_tooltip_message,
                    child: Icon(Icons.info, color: red),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        S
                            .of(context)
                            .estimator_accept_modal_step1_pickup_transport,
                        style:
                            TextHelper.customTextStyle(null, gray3, null, 16),
                      ),
                    ),
                  ),
                  Icon(
                    provider.workEstimateAcceptState ==
                            WorkEstimateAcceptState.PickUp
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: red,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _showInfo() {}
}
