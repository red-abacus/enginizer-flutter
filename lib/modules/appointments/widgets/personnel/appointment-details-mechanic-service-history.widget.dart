import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/appointment-mechanic.provider.dart';
import 'package:app/modules/appointments/widgets/cards/appointment-service-history.card.dart';
import 'package:app/modules/cars/models/recommendations/car-history.model.dart';
import 'package:app/modules/cars/models/recommendations/car-intervention.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsServiceHistory extends StatefulWidget {
  AppointmentDetailsServiceHistory();

  @override
  AppointmentDetailsServiceHistoryState createState() {
    return AppointmentDetailsServiceHistoryState();
  }
}

class AppointmentDetailsServiceHistoryState
    extends State<AppointmentDetailsServiceHistory> {
  AppointmentMechanicProvider _provider;

  CarHistory selectedCarHistory;
  CarIntervention selectedCarIntervention;

  @override
  Widget build(BuildContext context) {
    _provider =
        Provider.of<AppointmentMechanicProvider>(context, listen: false);

    List<dynamic> serviceHistory = _provider.carHistory;

    return serviceHistory.isNotEmpty
        ? _buildServiceHistory()
        : Center(
            child:
                Text(S.of(context).appointment_details_service_history_error));
  }

  _buildServiceHistory() {
    return ListView.builder(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 40, top: 10),
        shrinkWrap: true,
        itemCount: _provider.carHistory.length,
        itemBuilder: (context, index) {
          return AppointmentServiceHistoryCard(
            carHistory: _provider.carHistory[index],
            selectedCarHistory: selectedCarHistory,
            selectedCarIntervention: selectedCarIntervention,
            selectCarHistory: _selectCarHistory,
            selectCarIntervention: _selectCarIntervention,
          );
        });
  }

  _selectCarHistory(CarHistory carHistory) {
    this.selectedCarIntervention = null;
    setState(() {
      if (carHistory != selectedCarHistory) {
        selectedCarHistory = carHistory;
      } else {
        selectedCarHistory = null;
      }
    });
  }

  _selectCarIntervention(CarIntervention carIntervention) {
    setState(() {
      if (carIntervention != selectedCarIntervention) {
        selectedCarIntervention = carIntervention;
      } else {
        selectedCarIntervention = null;
      }
    });
  }
}
