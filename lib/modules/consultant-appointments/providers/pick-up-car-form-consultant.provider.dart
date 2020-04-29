import 'dart:io';

import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/consultant-appointments/enums/payment-method.enum.dart';
import 'package:app/modules/consultant-appointments/enums/tank-quantity.enum.dart';
import 'package:app/modules/consultant-appointments/models/assign-employee-request.model.dart';
import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';
import 'package:app/modules/consultant-appointments/models/employee.dart';
import 'package:app/modules/consultant-appointments/models/receive-form-request.model.dart';
import 'package:app/modules/consultant-appointments/models/receive-form.model.dart';
import 'package:flutter/cupertino.dart';

class PickUpCarFormConsultantProvider with ChangeNotifier {
  final ProviderService _providerService = inject<ProviderService>();
  final AppointmentsService _appointmentsService =
      inject<AppointmentsService>();

  int maxFiles = 5;

  GlobalKey<FormState> informationFormState;

  List<Employee> employees = [];

  EmployeeTimeSerie selectedTimeSerie;
  ReceiveFormRequest receiveFormRequest;

  resetParams() {
    selectedTimeSerie = null;
    informationFormState = null;

    receiveFormRequest = ReceiveFormRequest();
    receiveFormRequest.files.add(null);
  }

  Future<List<Employee>> getProviderEmployees(
      int providerId, String startDate, String endDate) async {
    try {
      this.employees = await _providerService.getProviderEmployees(
          providerId, startDate, endDate);
      notifyListeners();
      return this.employees;
    } catch (error) {
      throw (error);
    }
  }

  Future<int> createReceiveProcedure(
      ReceiveFormRequest receiveFormRequest) async {
    try {
      this.receiveFormRequest.receiveFormId =
          await _appointmentsService.createReceiveProcedure(receiveFormRequest);
      notifyListeners();
      return this.receiveFormRequest.receiveFormId;
    } catch (error) {
      throw (error);
    }
  }

  Future addReceiveProcedurePhotos(
      ReceiveFormRequest receiveFormRequest) async {
    try {
      if (receiveFormRequest.files.length == 0) {
        return;
      }
      await _appointmentsService.addReceiveProcedurePhotos(receiveFormRequest);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> assignEmployeeToAppointment(
      AssignEmployeeRequest assignEmployeeRequest) async {
    try {
      await _providerService.assignEmployeeToAppointment(assignEmployeeRequest);
      notifyListeners();
      return true;
    } catch (error) {
      throw (error);
    }
  }
}
