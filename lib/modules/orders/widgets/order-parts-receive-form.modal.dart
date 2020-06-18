import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPartsReceiveFormModal extends StatefulWidget {
  final AppointmentDetail orderDetails;
  final Function finishOrder;

  OrderPartsReceiveFormModal({this.orderDetails, this.finishOrder});

  @override
  State<StatefulWidget> createState() {
    return _OrderPartsReceiveFormModalState();
  }
}

class _OrderPartsReceiveFormModalState
    extends State<OrderPartsReceiveFormModal> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        heightFactor: .8,
        child: Container(
            child: ClipRRect(
          borderRadius: new BorderRadius.circular(5.0),
          child: Container(
            decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: Theme(
              data: ThemeData(
                  accentColor: Theme.of(context).primaryColor,
                  primaryColor: Theme.of(context).primaryColor),
              child: _buildContent(),
            ),
          ),
        )));
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              S.of(context).appointment_receive_car_form_title,
              style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 18),
            ),
            // TODO - need to check info for car reception form
            Container(
              margin: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                    text:
                        '${S.of(context).mechanic_appointment_receive_form_part_1}, ',
                    style: TextHelper.customTextStyle(color: gray3, size: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${DateUtils.stringFromDate(DateTime.now(), 'dd.MM.yyyy')}, ',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                      TextSpan(
                        text:
                            ' ${S.of(context).mechanic_appointment_receive_form_part_2}',
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      TextSpan(
                        text: Provider.of<Auth>(context)
                                .authUserDetails
                                ?.userProvider
                                ?.name ??
                            'AUTOWASS MANAGER SRL',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                      TextSpan(
                        text:
                            ' ${S.of(context).mechanic_appointment_receive_form_part_3} ',
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      TextSpan(
                        // tODO - need to add representative name for client
                        text: 'Mircea Pop',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                      TextSpan(
                        text:
                            ' ${S.of(context).mechanic_appointment_receive_form_part_4} ',
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      // TODO - need to add represantive name for service provider
                      TextSpan(
                        text: 'Mircea Pop.',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                    ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                    text:
                        '${S.of(context).mechanic_appointment_receive_form_part_5} ',
                    style: TextHelper.customTextStyle(color: gray3, size: 16),
                    children: <TextSpan>[
                      // TODO - need to add mechanic name
                      TextSpan(
                        text: 'Mircea Pop ',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                      TextSpan(
                        text: S
                            .of(context)
                            .mechanic_appointment_receive_form_part_6,
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      TextSpan(
                        text:
                            ' ${widget.orderDetails?.seller?.name ?? 'Mircea Pop'} ',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                      TextSpan(
                        text:
                            '${S.of(context).mechanic_appointment_receive_form_part_7}:',
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                    ]),
              ),
            ),
            Column(
              children: [
                for (IssueItem item in widget.orderDetails.items)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: RichText(
                      text: TextSpan(
                          text: '${S.of(context).estimator_product}: ',
                          style:
                              TextHelper.customTextStyle(color: gray3, size: 16),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${item.code ?? ''}, ${item.name ?? ''}',
                              style: TextHelper.customTextStyle(
                                  color: gray3, weight: FontWeight.bold, size: 16),
                            ),
                          ]),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: FlatButton(
                    color: gray2,
                    child: Text(S.of(context).mechanic_appointment_i_received,
                        style: TextHelper.customTextStyle(
                            color: Colors.white, size: 16)),
                    onPressed: () {
                      _showConfirmationAlert();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _showConfirmationAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertConfirmationDialogWidget(
          title: S.of(context).parts_confirm_parts_warning,
          confirmFunction: (confirmation) {
            if (confirmation) {
              Navigator.pop(context);
              widget.finishOrder(widget.orderDetails);
            }
          },
        );
      },
    );
  }
}
