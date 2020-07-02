import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/appointments/services/appointments.service.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:app/modules/auctions/models/work-estimate-details.model.dart';
import 'package:app/modules/auctions/services/bid.service.dart';
import 'package:app/modules/promotions/services/promotion.service.dart';
import 'package:app/modules/shop/models/shop-item.model.dart';
import 'package:app/modules/shop/services/shop.service.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/enums/issue-recommendation-status.enum.dart';
import 'package:app/modules/work-estimate-form/enums/transport-request.model.dart';
import 'package:app/modules/work-estimate-form/models/import-item-request.model.dart';
import 'package:app/modules/work-estimate-form/models/requests/issue-item-request.model.dart';
import 'package:app/modules/work-estimate-form/models/requests/order-issue-item-request.model.dart';
import 'package:app/modules/work-estimate-form/services/work-estimates.service.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/auctions/models/estimator/item-type.model.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/work-estimate-form/models/requests/work-estimate-request.model.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimateProvider with ChangeNotifier {
  ProviderService _providerService = inject<ProviderService>();
  WorkEstimatesService _workEstimatesService = inject<WorkEstimatesService>();
  AppointmentsService _appointmentsService = inject<AppointmentsService>();
  BidsService _bidsService = inject<BidsService>();
  ShopService _shopService = inject<ShopService>();

  static final Map<String, dynamic> initialEstimatorFormState = {
    'type': null,
    'code': null,
    'name': null,
    'quantity': '',
    'price': '',
    'priceVAT': '',
    'addition': 0.0
  };

  List<ItemType> itemTypes = [];
  List<ProviderItem> providerItems = [];
  List<IssueItem> itemsToImport = [];
  List<IssueItem> selectedItemsToOrder = [];
  List<IssueItem> itemsToOrder = [];
  List<ServiceProviderTimetable> serviceProviderTimetable = [];
  WorkEstimateRequest workEstimateRequest;
  WorkEstimateDetails workEstimateDetails;

  DateTime maxDate;
  List<ServiceProviderTimetable> timetable;
  DateEntry selectedDateEntry;

  AppointmentDetail selectedAppointmentDetail;
  AuctionDetail selectedAuctionDetails;

  int workEstimateId;
  int serviceProviderId;

  bool initDone = false;
  bool shouldAskForPr = true;

  List<IssueRecommendation> selectedRecommendations = [];

  Map<String, dynamic> estimatorFormState = Map.from(initialEstimatorFormState);

  int defaultQuantity;

  _initValues() {
    shouldAskForPr = false;
    defaultQuantity = null;
    selectedItemsToOrder = [];
    itemsToImport = [];
    itemsToOrder = [];
    itemTypes = [];
    providerItems = [];
    serviceProviderTimetable = [];
    workEstimateRequest = null;
    workEstimateDetails = null;
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
    try {
      providerItems = await _providerService.getProviderItems(
          serviceProviderId, query.toJson());
      notifyListeners();
      return providerItems;
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
      populateRecommendationsStatuses();
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

  Future<WorkEstimateDetails> addIssueItem(
      int workEstimateId, IssueItemRequest issueItemRequest) async {
    try {
      this.workEstimateDetails = await this
          ._workEstimatesService
          .addWorkEstimateItem(workEstimateId, issueItemRequest);
      notifyListeners();
      return workEstimateDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<IssueItem> updateIssueItem(
      int appointmentId, IssueItemRequest issueItemRequest) async {
    try {
      IssueItem issueItem = await _workEstimatesService.updateAppointmentItem(
          appointmentId, issueItemRequest);
      notifyListeners();
      return issueItem;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<IssueItem>> getAppointmentIssues(int appointmentId) async {
    try {
      List<IssueItem> issues =
          await this._appointmentsService.getAppointmentItems(appointmentId);
      itemsToImport = [];
      selectedItemsToOrder = [];
      itemsToOrder = [];

      issues.forEach((issue) {
        if (!issue.imported) {
          itemsToImport.add(issue);
        }

        if (issue.imported && issue.accepted && !issue.ordered) {
          itemsToOrder.add(issue);
        }
      });
      notifyListeners();
      return this.itemsToImport;
    } catch (error) {
      throw (error);
    }
  }

  Future<IssueItem> workEstimateImportIssueItem(
      int workEstimateId, ImportItemRequest importItemRequest) async {
    try {
      IssueItem issueItem = await this
          ._workEstimatesService
          .workEstimateImportItem(workEstimateId, importItemRequest);
      notifyListeners();
      return issueItem;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> sendRecommendations(
      int appointmentId, List<Map<String, dynamic>> request) async {
    try {
      bool response = await this
          ._appointmentsService
          .sendAppointmentRecommendations(appointmentId, request);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> orderAppointmentItems(
      int appointmentId, OrderIssueItemRequest request) async {
    try {
      AppointmentDetail appointmentDetail = await this
          ._appointmentsService
          .orderAppointmentItems(appointmentId, request);
      notifyListeners();
      return appointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  Future<AppointmentDetail> requestTransport(
      int appointmentId, TransportRequest request) async {
    try {
      AppointmentDetail appointmentDetail = await this
          ._appointmentsService
          .requestTransport(appointmentId, request);
      notifyListeners();
      return appointmentDetail;
    } catch (error) {
      throw (error);
    }
  }

  addRequestToIssueSection(
      Issue issue, IssueRecommendation issueRecommendation) {
    var issueItem = issueItemFromFormState();

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

  issueItemFromFormState() {
    return IssueItem(
        id: estimatorFormState['id'].id,
        type: estimatorFormState['type'],
        code: estimatorFormState['code'],
        name: estimatorFormState['name'],
        quantity: estimatorFormState['quantity'],
        price: estimatorFormState['price'],
        addition: estimatorFormState['addition'],
        priceVAT: estimatorFormState['priceVAT']);
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

  createWorkEstimateRequest(
      WorkEstimateDetails workEstimateDetails, EstimatorMode estimatorMode) {
    this.workEstimateRequest =
        workEstimateDetails.workEstimateRequest(estimatorMode);
  }

  createFinalWorkEstimateRequest(
      WorkEstimateDetails workEstimateDetails, EstimatorMode estimatorMode) {
    this.workEstimateRequest =
        workEstimateDetails.finalWorkEstimateRequest(estimatorMode);
  }

  double selectedRecommendationTotalCost() {
    double total = 0;
    for (IssueRecommendation recommendation in this.selectedRecommendations) {
      total += recommendation.totalCost();
    }
    return total;
  }

  populateRecommendationsStatuses() {
    if (selectedAppointmentDetail != null && workEstimateDetails != null) {
      List<IssueRecommendation> appointmentRecommendation =
          selectedAppointmentDetail.recommendations;

      this.workEstimateDetails.issues.forEach((issue) {
        for (IssueRecommendation workEstimateRecommendation
            in issue.recommendations) {
          if (workEstimateRecommendation.isStandard) {
            workEstimateRecommendation.status =
                IssueRecommendationStatus.Accepted;
            selectedRecommendations.add(workEstimateRecommendation);
          } else {
            for (IssueRecommendation appointmentRecommendation
                in appointmentRecommendation) {
              if (workEstimateRecommendation.id ==
                  appointmentRecommendation.id) {
                workEstimateRecommendation.status =
                    appointmentRecommendation.status;

                if (workEstimateRecommendation.status ==
                    IssueRecommendationStatus.Accepted) {
                  selectedRecommendations.add(workEstimateRecommendation);
                }
                break;
              }
            }
          }
        }
      });
    }
  }

  List<Map<String, dynamic>> getSendRecommendationRequest() {
    List<Map<String, dynamic>> request = [];

    selectedRecommendations.forEach((recommendation) {
      if (recommendation.status == IssueRecommendationStatus.New) {
        request.add(recommendation.sendRequest(true).toJson());
      }
    });

    workEstimateDetails.issues.forEach((issue) {
      for (IssueRecommendation recommendation in issue.recommendations) {
        if (recommendation.status == IssueRecommendationStatus.New) {
          if (!selectedRecommendations.contains(recommendation)) {
            request.add(recommendation.sendRequest(false).toJson());
          }
        }
      }
    });

    return request;
  }

  Future<List<ServiceProviderTimetable>> loadServiceProviderTimetables(
      int providerId, String startDate, String endDate) async {
    try {
      timetable = await _providerService.getServiceProviderTimetables(
          providerId, startDate, endDate);
      notifyListeners();
      return timetable;
    } catch (error) {
      throw (error);
    }
  }

  Future<ShopItem> getShopItemDetails(int promotionId) async {
    try {
      ShopItem shopItem = await _shopService.getShopItemDetails(promotionId);
      notifyListeners();
      return shopItem;
    } catch (error) {
      throw (error);
    }
  }
}
