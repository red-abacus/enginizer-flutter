import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/auctions/models/estimator/item-type.model.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/work-estimate-form/models/work-estimate-request.model.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimateProvider with ChangeNotifier {
  ProviderService _providerService = inject<ProviderService>();
  WorkEstimatesService _workEstimatesService = inject<WorkEstimatesService>();
  AppointmentsService _appointmentsService = inject<AppointmentsService>();

  static final Map<String, dynamic> initialEstimatorFormState = {
    'type': null,
    'code': null,
    'name': null,
    'quantity': '',
    'price': '',
    'priceVAT': ''
  };

  List<ItemType> itemTypes = [];
  List<ProviderItem> providerItems = [];
  List<ServiceProviderTimetable> serviceProviderTimetable = [];
  WorkEstimateRequest workEstimateRequest;
  WorkEstimateDetails workEstimateDetails;

  Appointment selectedAppointment;
  AppointmentDetail selectedAppointmentDetail;

  int workEstimateId;
  int serviceProviderId;

  Map<String, dynamic> estimatorFormState = Map.from(initialEstimatorFormState);

  _initValues() {
    itemTypes = [];
    providerItems = [];
    serviceProviderTimetable = [];
    workEstimateRequest = null;
    workEstimateDetails = null;
    selectedAppointment = null;
    selectedAppointmentDetail = null;
  }

  refreshValues() {
    _initValues();
    refreshForm();
    workEstimateRequest = WorkEstimateRequest();
  }

  refreshForm() {
    estimatorFormState = Map.from(initialEstimatorFormState);
  }

  void setIssues(List<Issue> issues) {
    for (Issue issue in issues) {
      issue.clearItems();
    }
    workEstimateRequest.issues = issues;
  }

  Future<AppointmentDetail> getAppointmentDetails(
      Appointment appointment) async {
    try {
      selectedAppointmentDetail =
      await this._appointmentsService.getAppointmentDetails(appointment.id);
      notifyListeners();
      return selectedAppointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ItemType>> loadItemTypes() async {
    try {
      var response = await _providerService.getItemTypes();
      itemTypes = response;
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<ProviderItem>> loadProviderItems(
      int serviceProviderId, IssueItemQuery query) async {
    try {
      var response = await _providerService.getProviderItems(
          serviceProviderId, query.toJson());
      providerItems = response;
      notifyListeners();
      return response;
    } catch (error) {
      throw(error);
    }
  }

  Future<List<ServiceProviderTimetable>> loadServiceProviderSchedule(
      int providerId, String startDate, String endDate) async {
    try {
      this.serviceProviderTimetable = await _providerService
          .getServiceProviderTimetables(providerId, startDate, endDate);
      notifyListeners();
      return this.serviceProviderTimetable;
    } catch (error) {
      throw (error);
    }
  }

  Future<WorkEstimateDetails> getWorkEstimateDetails(int workEstimateId) async {
    try {
      workEstimateDetails =
      await this._workEstimatesService.getWorkEstimateDetails(workEstimateId);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw(error);
    }
  }

  Future<WorkEstimateDetails> createWorkEstimate(int appointmentId, WorkEstimateRequest workEstimateRequest) async {
    Map<String, dynamic> content = workEstimateRequest.toJson();
    content['appointmentId'] = appointmentId;

    try {
      WorkEstimateDetails workEstimateDetails =
      await _workEstimatesService.addNewWorkEstimate(content);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw(error);
    }
  }

  addRequestToIssueSection(Issue issue, IssueRecommendation issueRecommendation) {
    var issueItem = IssueItem(
      type: estimatorFormState['type'],
      code: estimatorFormState['code'].code,
      name: estimatorFormState['name'].name,
      quantity: estimatorFormState['quantity'],
      price: estimatorFormState['price'],
      priceVAT: estimatorFormState['priceVAT'],
    );

    for (Issue temp in workEstimateRequest.issues) {
      if (temp == issue) {
        List<IssueRecommendation> sections = temp.recommendations;

        for (IssueRecommendation tempIssueRecommendation in sections) {
          if (tempIssueRecommendation == issueRecommendation) {
            tempIssueRecommendation.items.insert(0, issueItem);
            break;
          }
        }
        break;
      }
    }
  }

  removeIssueItem(
      Issue issue, IssueRecommendation issueRecommendation, IssueItem issueItem) {
    for (Issue temp in workEstimateRequest.issues) {
      if (temp == issue) {
        List<IssueRecommendation> sections = temp.recommendations;

        for (IssueRecommendation tempIssueRecommendation in sections) {
          if (tempIssueRecommendation == issueRecommendation) {
            tempIssueRecommendation.items.remove(issueItem);
            break;
          }
        }
        break;
      }
    }
  }

  selectIssueSection(Issue issue, IssueRecommendation issueRecommendation) {
    for (Issue temp in workEstimateRequest.issues) {
      if (temp == issue) {
        List<IssueRecommendation> sections = temp.recommendations;

        for (IssueRecommendation tempIssueRecommendation in sections) {
          if (tempIssueRecommendation == issueRecommendation) {
            tempIssueRecommendation.selected = !tempIssueRecommendation.selected;

            if (tempIssueRecommendation.selected) {
              tempIssueRecommendation.expanded = true;
            }
            break;
          }
        }
        break;
      }
    }
  }

  createWorkEstimateRequest(WorkEstimateDetails workEstimateDetails) {
    this.workEstimateRequest = workEstimateDetails.workEstimateRequest();
  }
}
