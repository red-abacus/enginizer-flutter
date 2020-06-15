
import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/enum/pick-up-form-state.enum.dart';
import 'package:app/modules/appointments/model/personnel/employee-timeserie.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/appointments/model/request/assign-employee-request.model.dart';
import 'package:app/modules/appointments/model/personnel/employee.dart';
import 'package:app/modules/appointments/model/request/receive-form-request.model.dart';
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

  PickupFormState pickupFormState;

  initialise() {
    selectedTimeSerie = null;
    informationFormState = null;

    receiveFormRequest = ReceiveFormRequest();
    receiveFormRequest.files.add(null);
  }

  Future<List<Employee>> getProviderEmployees(int providerId, String startDate,
      String endDate) async {
    try {
      this.employees = await _providerService.getProviderEmployees(
          providerId, startDate, endDate);
      notifyListeners();
      return this.employees;
    } catch (error) {
      throw (error);
    }
  }

  Future<int> createProcedure(
      ReceiveFormRequest receiveFormRequest, PickupFormState pickupFormState) async {
    try {
      if (pickupFormState == PickupFormState.Receive) {
        this.receiveFormRequest.receiveFormId =
        await _appointmentsService.createReceiveProcedure(receiveFormRequest);
      }
      else {
        this.receiveFormRequest.receiveFormId =
        await _appointmentsService.createReturnProcedure(receiveFormRequest);
      }

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

  Future<bool> assignEmployeeToAppointment(int appointmentId,
      AssignEmployeeRequest assignEmployeeRequest) async {
    try {
      await _appointmentsService.assignEmployee(
          appointmentId, assignEmployeeRequest);
      notifyListeners();
      return true;
    } catch (error) {
      throw (error);
    }
  }
}
