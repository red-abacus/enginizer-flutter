import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/request/appointment-request.model.dart';
import 'package:app/modules/appointments/providers/appointments.provider.dart';
import 'package:app/modules/appointments/providers/provider-service.provider.dart';
import 'package:app/modules/appointments/widgets/appointment-create-modal.widget.dart';
import 'package:app/modules/cars/models/recommendations/car-history.model.dart';
import 'package:app/modules/cars/models/recommendations/car-intervention.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/modules/cars/widgets/cards/car-history.card.dart';
import 'package:app/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarRecommendationsWidget extends StatefulWidget {
  final List<CarHistory> carHistory;

  CarRecommendationsWidget({this.carHistory});

  @override
  State<StatefulWidget> createState() {
    return _CarRecommendationsWidgetState();
  }
}

class _CarRecommendationsWidgetState extends State<CarRecommendationsWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.carHistory.length == 0
        ? Center(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).cars_no_recommendations_title,
                      textAlign: TextAlign.center,
                      style: TextHelper.customTextStyle(
                          null, gray3, FontWeight.bold, 16),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20, bottom: 80),
                shrinkWrap: true,
                itemCount: widget.carHistory.length,
                itemBuilder: (context, index) {
                  return CarHistoryCard(
                      carHistory: widget.carHistory[index],
                      selectIntervention: _selectIntervention);
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: null,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 1,
              onPressed: () => {_showAppointmentModal()},
              child: Icon(Icons.add),
            ),
          );
  }

  _selectIntervention(CarIntervention carIntervention) {
    CarProvider carProvider = Provider.of<CarProvider>(context);

    setState(() {
      if (carProvider.selectedInterventions.contains(carIntervention)) {
        carProvider.selectedInterventions.remove(carIntervention);
      } else {
        carProvider.selectedInterventions.add(carIntervention);
      }
    });
  }

  _showAppointmentModal() {
    CarProvider carProvider = Provider.of<CarProvider>(context);

    if (carProvider.selectedInterventions.length == 0) {
      AlertWarningDialog.showAlertDialog(context, S.of(context).general_warning,
          S.of(context).car_create_appointment_from_interventions_alert);
    } else {
      Provider.of<ProviderServiceProvider>(context).initFormValues();
      Provider.of<ProviderServiceProvider>(context).selectedCar = carProvider.selectedCar;
      Provider.of<ProviderServiceProvider>(context).issuesFormState = [];

      carProvider.selectedInterventions.forEach((intervention) {
        Provider.of<ProviderServiceProvider>(context)
            .issuesFormState
            .add(Issue(name: intervention.name));
      });

      showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return AppointmentCreateModal(
                  _createAppointment, false, carProvider.selectedCar);
            });
          });
    }
  }

  _createAppointment(AppointmentRequest appointmentRequest) async {
    try {
      await Provider.of<AppointmentsProvider>(context)
          .createAppointment(appointmentRequest)
          .then((_) {
        Navigator.pop(context);
      });
    } catch (error) {
      FlushBarHelper.showFlushBar(S.of(context).general_error,
          S.of(context).exception_create_appointment, context);
    }
  }
}
