import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/auctions/services/work-estimates.service.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-section.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/auctions/models/estimator/item-type.model.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/work-estimate-form/models/work-estimate-request.model.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimateProvider with ChangeNotifier {
  ProviderService _providerService = inject<ProviderService>();
  WorkEstimatesService _workEstimatesService = inject<WorkEstimatesService>();

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

  Future<WorkEstimateDetails> createWorkEstimate(int appointmentId, int carId,
      int clientId, WorkEstimateRequest workEstimateRequest) async {
    Map<String, dynamic> content = workEstimateRequest.toJson();

    try {
      WorkEstimateDetails workEstimateDetails =
      await _workEstimatesService.addNewWorkEstimate(content);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw(error);
    }
  }

  addRequestToIssueSection(Issue issue, IssueSection issueSection) {
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
        List<IssueSection> sections = temp.sections;

        for (IssueSection tempIssueSection in sections) {
          if (tempIssueSection == issueSection) {
            tempIssueSection.items.insert(0, issueItem);
            break;
          }
        }
        break;
      }
    }
  }

  removeIssueRefactorItem(
      Issue issue, IssueSection issueSection, IssueItem issueItem) {
    for (Issue temp in workEstimateRequest.issues) {
      if (temp == issue) {
        List<IssueSection> sections = temp.sections;

        for (IssueSection tempIssueSection in sections) {
          if (tempIssueSection == issueSection) {
            tempIssueSection.items.remove(issueItem);
            break;
          }
        }
        break;
      }
    }
  }

  selectIssueSection(Issue issue, IssueSection issueSection) {
    for (Issue temp in workEstimateRequest.issues) {
      if (temp == issue) {
        List<IssueSection> sections = temp.sections;

        for (IssueSection tempIssueSection in sections) {
          if (tempIssueSection == issueSection) {
            tempIssueSection.selected = !tempIssueSection.selected;

            if (tempIssueSection.selected) {
              tempIssueSection.expanded = true;
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
