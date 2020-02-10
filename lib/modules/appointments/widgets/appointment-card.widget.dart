import 'package:enginizer_flutter/modules/appointments/model/appointment-status.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
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
                  Container(
                    width: 132,
                    height: 132,
                    padding: EdgeInsets.all(20),
                    color: _resolveStatusColor(appointment.status),
                    child: SvgPicture.asset(
                      'assets/images/statuses/${appointment.status?.name}.svg'
                          .toLowerCase(),
                      semanticsLabel: 'Appointment Status Image',
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              '${appointment.car?.brand?.name} ${appointment.car?.model?.name} - ${appointment.status?.name}',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  height: 1.5)),
                          Text('${appointment.scheduleDateTime}',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.8,
                                  height: 1.5)),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Type: ',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.2,
                                      height: 1.5)),
                              Expanded(
                                child: Text(
                                    '${appointment.appointmentTypes.fold('', (s, appointmentType) => s + '${appointmentType.name}, ')}',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Lato',
                                        fontSize: 11.2,
                                        height: 1.5)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Operating unit: ',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.2,
                                      height: 1.5)),
                              Text(
                                  '${appointment.operatingUnit?.name ?? 'Bid Mode'}',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Lato',
                                      fontSize: 11.2,
                                      height: 1.5)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  static _resolveStatusColor(AppointmentStatus status) {
    switch (status.name.toLowerCase()) {
      case 'completed':
        return Constants.green;
      case 'in_work':
        return Constants.yellow;
      case 'submitted':
        return Constants.gray;
      case 'canceled':
        return Constants.red;
    }
  }
}
