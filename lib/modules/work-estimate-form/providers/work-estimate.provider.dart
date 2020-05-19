import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
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
  BidsService _bidsService = inject<BidsService>();

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
  AuctionDetail selectedAuctionDetails;

  int workEstimateId;
  int serviceProviderId;

  List<IssueRecommendation> selectedRecommendations = [];

  Map<String, dynamic> estimatorFormState = Map.from(initialEstimatorFormState);

  _initValues() {
    itemTypes = [];
    providerItems = [];
    serviceProviderTimetable = [];
    workEstimateRequest = null;
    workEstimateDetails = null;
    selectedAppointment = null;
    selectedAppointmentDetail = null;
    selectedRecommendations = [];
  }

  refreshValues(EstimatorMode estimatorMode) {
    _initValues();
    refreshForm();
    workEstimateRequest = WorkEstimateRequest(estimatorMode);
  }

  refreshForm() {
    estimatorFormState = Map.from(initialEstimatorFormState);
  }

  void setIssues(BuildContext context, List<Issue> issues) {
    for (Issue issue in issues) {
      issue.clearItems();
    }
    workEstimateRequest.setIssues(context, issues);
  }

  void setIssuesWithRecommendations(List<Issue> issues) {
    issues.forEach((issue) {
      issue.clearRecommendationsItems();
    });
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
    print('load provider items ${serviceProviderId}');
    try {
      var response = await _providerService.getProviderItems(
          serviceProviderId, query.toJson());
      print('za response $response');
      providerItems = response;
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
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
      workEstimateDetails = await this
          ._workEstimatesService
          .getWorkEstimateDetails(workEstimateId);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<WorkEstimateDetails> createWorkEstimate(
      WorkEstimateRequest workEstimateRequest,
      {int appointmentId,
      int auctionId}) async {
    Map<String, dynamic> content = workEstimateRequest.toJson();

    if (appointmentId != null) {
      content['appointmentId'] = appointmentId;
    } else if (auctionId != null) {
      content['auctionId'] = auctionId;
    }

    try {
      WorkEstimateDetails workEstimateDetails =
          await _workEstimatesService.addNewWorkEstimate(content);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> rejectWorkEstimate(int workEstimateId) async {
    try {
      bool response =
          await this._workEstimatesService.rejectWorkEstimate(workEstimateId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> acceptBid(int bidId) async {
    try {
      bool response = await this._bidsService.acceptBid(bidId);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  addRequestToIssueSection(
      Issue issue, IssueRecommendation issueRecommendation) {
    var issueItem = IssueItem(
      id: estimatorFormState['id'],
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

  removeIssueItem(Issue issue, IssueRecommendation issueRecommendation,
      IssueItem issueItem) {
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

  createWorkEstimateRequest(WorkEstimateDetails workEstimateDetails, EstimatorMode estimatorMode) {
    this.workEstimateRequest = workEstimateDetails.workEstimateRequest(estimatorMode);
  }

  createFinalWorkEstimateRequest(WorkEstimateDetails workEstimateDetails, EstimatorMode estimatorMode) {
    this.workEstimateRequest = workEstimateDetails.finalWorkEstimateRequest(estimatorMode);
  }

  double selectedRecommendationTotalCost() {
    double total = 0;
    for (IssueRecommendation recommendation in this.selectedRecommendations) {
      total += recommendation.totalCost();
    }
    return total;
  }
}
