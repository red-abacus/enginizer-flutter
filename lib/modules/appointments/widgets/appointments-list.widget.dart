import 'package:enginizer_flutter/generated/i18n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'appointment-card.widget.dart';

class AppointmentsList extends StatelessWidget {
  List<Appointment> appointments = [];

  Function selectAppointment;
  Function filterAppointments;

  AppointmentsList(
      {this.appointments, this.selectAppointment, this.filterAppointments});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildSearchBar(context),
              _buildListView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      child: TextField(
        key: Key('searchBar'),
        style: TextHelper.customTextStyle(null, null, null, null),
        autofocus: false,
        decoration: InputDecoration(
            labelText: S.of(context).appointments_list_search_hint),
        onChanged: (val) {
          filterAppointments(val);
        },
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return new Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return AppointmentCard(
                appointment: this.appointments.elementAt(index),
                selectAppointment: this.selectAppointment);
          },
          itemCount: this.appointments.length,
        ),
      ),
    );
  }
}
