import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'appointment-card.dart';

class AppointmentsList extends StatelessWidget {
  List<Appointment> appointments = [];
  Function selectAppointment;

  AppointmentsList({this.appointments, this.selectAppointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Material(
        elevation: 1,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                    child: Container(
                      child: TextField(
                        key: Key('searchBar'),
                        autofocus: false,
                        decoration:
                            InputDecoration(labelText: 'Find appointment'),
                        onChanged: (val) {
                          print(val);
                        },
                      ),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .7,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return AppointmentCard(
                          appointment: this.appointments.elementAt(index),
                          selectAppointment: this.selectAppointment);
                    },
                    itemCount: this.appointments.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
