import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/car-receive-form-state.enum.dart';
import 'package:app/modules/appointments/enum/pick-up-form-state.enum.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/enum/receive-car-form-state.enum.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/pick-up-car-form-consultant.modal.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentCarReceiveFormModal extends StatefulWidget {
  final AppointmentDetail appointmentDetail;
  final Function refreshState;
  final CarReceiveFormState carReceiveFormState;
  final PickupFormState pickupFormState;

  AppointmentCarReceiveFormModal(
      {this.appointmentDetail,
      this.refreshState,
      this.carReceiveFormState,
      this.pickupFormState});

  @override
  State<StatefulWidget> createState() {
    return _AppointmentCarReceiveFormModalState();
  }
}

class _AppointmentCarReceiveFormModalState
    extends State<AppointmentCarReceiveFormModal> {
  bool _showPickUpButton = false;
  ReceiveCarFormState _receiveCarFormState = ReceiveCarFormState.FORM;

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
      return widget.pickupFormState == PickupFormState.Receive
          ? _receiveFormContainer()
          : _returnFormContainer();
    }

    return PickUpCarFormConsultantWidget(
        carReceiveFormState: widget.carReceiveFormState,
        appointmentDetail: widget.appointmentDetail,
        refreshState: widget.refreshState,
        pickupFormState: widget.pickupFormState);
  }

  _receiveFormContainer() {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              S.of(context).mechanic_appointment_receive_form_title,
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold, size: 18),
            ),
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
                        text: S
                            .of(context)
                            .mechanic_appointment_receive_form_part_2,
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      TextSpan(
                        text:
                            ' ${widget.appointmentDetail?.serviceProvider?.name}',
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
                        // TODO - need to add representative name for service provider
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
                      TextSpan(
                        // TODO - need to add representative name for representative service provider
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
                        text: ' ${widget.appointmentDetail?.user?.name} ',
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
            Container(
              margin: EdgeInsets.only(top: 10),
              child: RichText(
                text: TextSpan(
                    text:
                        '${S.of(context).mechanic_appointment_receive_form_part_8}: ',
                    style: TextHelper.customTextStyle(color: gray3, size: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${widget.appointmentDetail?.car?.registrationNumber}, ${widget.appointmentDetail?.car?.brand?.name}, ${widget.appointmentDetail?.car?.year?.name}, ${widget.appointmentDetail?.car?.color?.translateColorName(context)}',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
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
                            color: Colors.white, size: 16)),
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
                              color: Colors.white, size: 16)),
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

  _returnFormContainer() {
    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.pickupFormState == PickupFormState.Receive
                  ? S.of(context).mechanic_appointment_receive_form_title
                  : S.of(context).mechanic_appointment_hand_form_title,
              style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 18),
            ),
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
                        text: S.of(context).general_by,
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      TextSpan(
                        text:
                            ' ${widget.appointmentDetail?.serviceProvider?.name}.',
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
                      TextSpan(
                        text:
                            '${widget.appointmentDetail?.serviceProvider?.name} ',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                      TextSpan(
                        text:
                            '${S.of(context).mechanic_appointment_return_form_part_1}:',
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
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
                    style: TextHelper.customTextStyle(color: gray3, size: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${widget.appointmentDetail?.car?.registrationNumber}, ${widget.appointmentDetail?.car?.brand?.name}, ${widget.appointmentDetail?.car?.year?.name}, ${widget.appointmentDetail?.car?.color?.translateColorName(context)}',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
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
                    child: Text(
                        widget.pickupFormState == PickupFormState.Receive
                            ? S.of(context).mechanic_appointment_i_received
                            : S.of(context).mechanic_appointment_i_handed_over,
                        style: TextHelper.customTextStyle(
                            color: Colors.white, size: 16)),
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
                              color: Colors.white, size: 16)),
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
          title: widget.pickupFormState == PickupFormState.Receive
              ? S.of(context).mechanic_appointment_receive_form_alert_title
              : S.of(context).mechanic_appointment_handover_form_alert_title,
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
