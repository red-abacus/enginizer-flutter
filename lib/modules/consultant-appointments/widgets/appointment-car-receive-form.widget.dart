import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/consultant-appointments/enums/receive-car-form-state.enum.dart';
import 'package:app/modules/consultant-appointments/widgets/pick-up-form/pick-up-car-form-consultant.modal.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentCarReceiveFormModal extends StatefulWidget {
  final AppointmentDetail appointmentDetail;
  final Function createCarReceiveForm;

  AppointmentCarReceiveFormModal(
      {this.appointmentDetail, this.createCarReceiveForm});

  @override
  State<StatefulWidget> createState() {
    return _AppointmentCarReceiveFormModalState();
  }
}

class _AppointmentCarReceiveFormModalState
    extends State<AppointmentCarReceiveFormModal> {
  bool _showPickUpButton = false;
  // tODO - remove this
  ReceiveCarFormState _receiveCarFormState = ReceiveCarFormState.EXTENDED_FORM;
//  ReceiveCarFormState _receiveCarFormState = ReceiveCarFormState.FORM;

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
    if (_receiveCarFormState == ReceiveCarFormState.FORM) {
      return _formContainer();
    }

    return PickUpCarFormConsultantWidget(appointmentDetail: widget.appointmentDetail);
  }

  _formContainer() {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              S.of(context).mechanic_appointment_receive_form_title,
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 18),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                    text:
                        '${S.of(context).mechanic_appointment_receive_form_part_1}, ',
                    style: TextHelper.customTextStyle(null, gray3, null, 16),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${DateUtils.stringFromDate(DateTime.now(), 'dd.MM.yyyy')}, ',
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                      TextSpan(
                        text: S
                            .of(context)
                            .mechanic_appointment_receive_form_part_2,
                        style:
                            TextHelper.customTextStyle(null, gray3, null, 16),
                      ),
                      TextSpan(
                        text:
                            ' ${widget.appointmentDetail?.serviceProvider?.name}',
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                      TextSpan(
                        text:
                            ' ${S.of(context).mechanic_appointment_receive_form_part_3} ',
                        style:
                            TextHelper.customTextStyle(null, gray3, null, 16),
                      ),
                      TextSpan(
                        // tODO - need to add representative name for client
                        text: 'Mircea Pop',
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                      TextSpan(
                        text:
                            ' ${S.of(context).mechanic_appointment_receive_form_part_4} ',
                        style:
                            TextHelper.customTextStyle(null, gray3, null, 16),
                      ),
                      // TODO - need to add represantive name for service provider
                      TextSpan(
                        text: 'Mircea Pop.',
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
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
                    style: TextHelper.customTextStyle(null, gray3, null, 16),
                    children: <TextSpan>[
                      // TODO - need to add mechanic name
                      TextSpan(
                        text: 'Mircea Pop ',
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                      TextSpan(
                        text: S
                            .of(context)
                            .mechanic_appointment_receive_form_part_6,
                        style:
                            TextHelper.customTextStyle(null, gray3, null, 16),
                      ),
                      TextSpan(
                        text: ' ${widget.appointmentDetail?.user?.name} ',
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                      TextSpan(
                        text:
                            '${S.of(context).mechanic_appointment_receive_form_part_7}:',
                        style:
                            TextHelper.customTextStyle(null, gray3, null, 16),
                      ),
                    ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                    text:
                        '${S.of(context).mechanic_appointment_receive_form_part_8}: ',
                    style: TextHelper.customTextStyle(null, gray3, null, 16),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${widget.appointmentDetail?.car?.registrationNumber}, ${widget.appointmentDetail?.car?.brand?.name}, ${widget.appointmentDetail?.car?.year?.name}, ${widget.appointmentDetail?.car?.color?.translateColorName(context)}',
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                    ]),
              ),
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
                            null, Colors.white, FontWeight.normal, 16)),
                    onPressed: () {
                      _showConfirmationAlert();
                    },
                  ),
                ),
                if (_showPickUpButton)
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: FlatButton(
                      color: gray2,
                      child: Text(S.of(context).appointment_extended_form,
                          style: TextHelper.customTextStyle(
                              null, Colors.white, FontWeight.normal, 16)),
                      onPressed: () {
                        _showExtendedForm();
                      },
                    ),
                  )
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
          title: S.of(context).mechanic_appointment_receive_form_alert_title,
          confirmFunction: (confirmation) {
            if (confirmation) {
              setState(() {
                _showPickUpButton = true;
              });
            }
          },
        );
      },
    );
  }

  _showExtendedForm() {
    setState(() {
      _receiveCarFormState = ReceiveCarFormState.EXTENDED_FORM;
    });
  }
}
