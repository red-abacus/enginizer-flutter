import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/enum/car-receive-form-state.enum.dart';
import 'package:app/modules/appointments/enum/pick-up-form-state.enum.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/enum/receive-car-form-state.enum.dart';
import 'package:app/modules/appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/widgets/pick-up-form/pick-up-car-form-consultant.modal.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  bool _initDone = false;
  bool _isLoading = false;

  PickUpCarFormConsultantProvider _provider;

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
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildContent(),
            ),
          ),
        )));
  }

  @override
  Future<void> didChangeDependencies() async {
    if (!_initDone) {
      _provider = Provider.of<PickUpCarFormConsultantProvider>(context);

      setState(() {
        _isLoading = true;
      });

      try {
        await _provider
            .getProcedureInfo(
                widget.appointmentDetail.id, PickupFormState.Receive)
            .then((_) async {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        if (error.toString().contains(
            AppointmentsService.GET_RECEIVE_PROCEDURE_INFO_EXCEPTION)) {
          FlushBarHelper.showFlushBar(S.of(context).general_error,
              S.of(context).exception_receive_procedure_info, context);
        }

        setState(() {
          _isLoading = false;
        });
      }
    }

    _initDone = true;

    super.didChangeDependencies();
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
                            ' ${_provider.procedureInfo?.receivedBy?.providerName ?? '-'}',
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
                        text:
                            '${_provider.procedureInfo?.receivedBy?.userName ?? '-'}',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                      TextSpan(
                        text:
                            ' ${S.of(context).mechanic_appointment_receive_form_part_4} ',
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      TextSpan(
                        text:
                            '${_provider.procedureInfo?.handoverBy?.userName ?? '-'}.',
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
                            '${_provider.procedureInfo?.receivedBy?.providerName ?? '-'} ',
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
                        text: ' ${_provider.procedureInfo?.handoverBy?.userName ?? '-'} ',
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
                            '${_provider.procedureInfo?.car?.registrationNumber}, ${_provider.procedureInfo?.car?.brand?.name}, ${_provider.procedureInfo?.car?.year?.name}, ${_provider.procedureInfo?.car?.color?.translateColorName(context)}',
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
                        text: S.of(context).mechanic_appointment_receive_form_part_2,
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      TextSpan(
                        text:
                            ' ${_provider.procedureInfo.receivedBy?.providerName ?? '-'}',
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
                        text:
                        '${_provider.procedureInfo?.receivedBy?.userName ?? '-'}.',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                      TextSpan(
                        text:
                        ' ${S.of(context).mechanic_appointment_receive_form_part_4} ',
                        style:
                        TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      TextSpan(
                        text:
                        '${_provider.procedureInfo?.handoverBy?.userName ?? '-'}.',
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
                            '${_provider.procedureInfo?.receivedBy?.providerName ?? '-'} ',
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
                        text:
                        '${_provider.procedureInfo?.receivedBy?.userName ?? '-'} ',
                        style: TextHelper.customTextStyle(
                            color: gray3, weight: FontWeight.bold, size: 16),
                      ),
                      TextSpan(
                        text:
                            '${S.of(context).mechanic_appointment_return_form_part_1}',
                        style:
                            TextHelper.customTextStyle(color: gray3, size: 16),
                      ),
                      TextSpan(
                        text:
                        ' ${_provider.procedureInfo?.handoverBy?.userName ?? '-'}:',
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
                        '${S.of(context).mechanic_appointment_receive_form_part_8}: ',
                    style: TextHelper.customTextStyle(color: gray3, size: 16),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${_provider.procedureInfo?.car?.registrationNumber}, ${_provider.procedureInfo?.car?.brand?.name}, ${_provider.procedureInfo?.car?.year?.name}, ${_provider.procedureInfo?.car?.color?.translateColorName(context)}',
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
