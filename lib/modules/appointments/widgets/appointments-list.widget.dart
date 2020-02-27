import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/auctions/enum/appointment-status.enum.dart';
import 'package:enginizer_flutter/modules/shared/widgets/datepicker.widget.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appointment-card.widget.dart';

class AppointmentsList extends StatelessWidget {
  List<Appointment> appointments = [];

  String searchString;
  AppointmentStatusState appointmentStatusState;
  DateTime filterDateTime;

  Function selectAppointment;
  Function filterAppointments;

  AppointmentsList(
      {this.appointments,
      this.selectAppointment,
      this.filterAppointments,
      this.searchString,
      this.appointmentStatusState,
      this.filterDateTime});

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
              _buildFilterWidget(context),
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
          filterAppointments(
              val, this.appointmentStatusState, this.filterDateTime);
        },
      ),
    );
  }

  Widget _buildFilterWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(right: 10),
            child: DropdownButtonFormField(
              isDense: true,
              hint: _statusText(context),
              items: _statusDropdownItems(context),
              onChanged: (newValue) {
                filterAppointments(
                    this.searchString, newValue, this.filterDateTime);
              },
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              height: 70,
              child: BasicDateField(
                labelText: S.of(context).general_date,
                onChange: (value) {
                  filterAppointments(
                      this.searchString, this.appointmentStatusState, value);
                },
              ),
            )),
      ],
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

  Widget _statusText(BuildContext context) {
    String title = (this.appointmentStatusState == null)
        ? S.of(context).general_status
        : Appointment.getTitleForState(context, this.appointmentStatusState);

    return Text(
      title,
      style: TextHelper.customTextStyle(null, Colors.grey, null, 15),
    );
  }

  _statusDropdownItems(BuildContext context) {
    List<DropdownMenuItem<AppointmentStatusState>> brandDropdownList = [];
    brandDropdownList.add(DropdownMenuItem(
        value: AppointmentStatusState.ALL,
        child: Text(Appointment.getTitleForState(context, AppointmentStatusState.ALL))));
    brandDropdownList.add(DropdownMenuItem(
        value: AppointmentStatusState.SCHEDULED,
        child: Text(Appointment.getTitleForState(context, AppointmentStatusState.SCHEDULED))));
    brandDropdownList.add(DropdownMenuItem(
        value: AppointmentStatusState.SUBMITTED,
        child: Text(Appointment.getTitleForState(context, AppointmentStatusState.SUBMITTED))));
    brandDropdownList.add(DropdownMenuItem(
        value: AppointmentStatusState.PENDING,
        child: Text(Appointment.getTitleForState(context, AppointmentStatusState.PENDING))));
    brandDropdownList.add(DropdownMenuItem(
        value: AppointmentStatusState.IN_WORK,
        child: Text(Appointment.getTitleForState(context, AppointmentStatusState.IN_WORK))));
    return brandDropdownList;
  }
}
