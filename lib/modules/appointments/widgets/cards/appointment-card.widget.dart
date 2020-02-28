import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/auctions/enum/appointment-status.enum.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:enginizer_flutter/utils/constants.dart' as Constants;

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final Function selectAppointment;

  AppointmentCard({this.appointment, this.selectAppointment});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            onTap: () => this.selectAppointment(context, this.appointment),
            child: ClipRRect(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _imageContainer(),
                  _textContainer(),
                  _statusContainer(context),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _imageContainer() {
    return Container(
      width: 132,
      height: 132,
      padding: EdgeInsets.all(20),
      color: appointment.resolveStatusColor(),
      child: SvgPicture.asset(
        'assets/images/statuses/${appointment.assetName()}.svg'.toLowerCase(),
        semanticsLabel: 'Appointment Status Image',
      ),
    );
  }

  _textContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        height: 132,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text('${appointment.car?.registrationNumber}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.5)),
                Text(
                    '${appointment.car?.brand?.name} ${appointment.car?.model?.name} ${appointment.car?.year?.name}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.8,
                        height: 1.5)),
                Text('${appointment.scheduleDateTime}',
                    style: TextStyle(
                        color: Constants.gray,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        height: 1.5)),
                SizedBox(height: 10),
              ],
            ),
            Positioned(
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(appointment.name,
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            fontSize: 11.2,
                            height: 1.5)),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _statusContainer(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Text(
          AppointmentStatusStateUtils.title(context, appointment.getState()).toUpperCase(),
          textAlign: TextAlign.right,
          style: TextHelper.customTextStyle(
              null, appointment.resolveStatusColor(), FontWeight.bold, 12),
        ),
      ),
    );
  }
}
