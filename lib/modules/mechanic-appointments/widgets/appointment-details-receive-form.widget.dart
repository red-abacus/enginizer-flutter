import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/mechanic-appointments/widgets/general/appointment-mechanic-receive-form.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsReceiveFormWidget extends StatelessWidget {
  final AppointmentDetail appointmentDetails;

  AppointmentDetailsReceiveFormWidget({this.appointmentDetails});

  @override
  Widget build(BuildContext context) {
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
                        text: ' ${appointmentDetails?.serviceProvider?.name}',
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                      TextSpan(
                        text:
                            ' ${S.of(context).mechanic_appointment_receive_form_part_3} ',
                        style:
                            TextHelper.customTextStyle(null, gray3, null, 16),
                      ),
                      // TODO - need to add represantive name for service provider
                      TextSpan(
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
                        text: ' ${appointmentDetails?.user?.name} ',
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
                            '${appointmentDetails?.car?.registrationNumber}, ${appointmentDetails?.car?.brand?.name}, ${appointmentDetails?.car?.year?.name}, ${appointmentDetails?.car?.color?.translateColorName(context)}',
                        style: TextHelper.customTextStyle(
                            null, gray3, FontWeight.bold, 16),
                      ),
                    ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: FlatButton(
                color: gray2,
                child: Text(S.of(context).mechanic_appointment_i_received,
                style: TextHelper.customTextStyle(null, Colors.white, FontWeight.normal, 16)), onPressed: () {
                  _showConfirmationAlert(context);
              },
              ),
            )
          ],
        ),
      ),
    );
  }

  _showConfirmationAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppointmentMechanicReceiveFormWidget(
          confirmFunction: (confirmation) {
            // TODO - need to do something this confirmation
            if (confirmation) {
            }
          },
        );
      },
    );
  }
}
