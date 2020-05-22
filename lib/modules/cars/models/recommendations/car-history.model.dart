import 'package:app/utils/date_utils.dart';

import 'car-intervention.model.dart';

class CarHistory {
  String appointmentName;
  DateTime appointmentScheduledDateTime;

  List<CarIntervention> interventions = [];

  CarHistory(
      {this.appointmentName = '',
      this.appointmentScheduledDateTime,
      this.interventions});

  factory CarHistory.fromJson(Map<String, dynamic> json) {
    return CarHistory(
        appointmentName: json['appointmentName'],
        appointmentScheduledDateTime:
            json['appointmentScheduledDateTime'] != null
                ? DateUtils.dateFromString(
                    json['appointmentScheduledDateTime'], 'dd/MM/yyyy HH:mm')
                : null,
        interventions: _mapInterventions(json['interventions']));
  }

  static _mapInterventions(List<dynamic> response) {
    List<CarIntervention> interventions = [];
    response.forEach((intervention) {
      interventions.add(CarIntervention.fromJson(intervention));
    });
    return interventions;
  }
}
