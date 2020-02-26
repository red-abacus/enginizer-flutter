import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/item-type.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';

class CreateWorkEstimateProvider with ChangeNotifier {
  ProviderService providerService = inject<ProviderService>();

  static final Map<String, dynamic> initialEstimatorFormState = {
    'type': null,
    'code': null,
    'name': null,
    'quantity': '',
    'price': '',
    'priceVAT': ''
  };

  List<Issue> issues = [];
  List<ItemType> itemTypes = [];
  List<ProviderItem> providerItems = [];
  List<ServiceProviderTimetable> serviceProviderTimetable = [];

  Map<String, dynamic> estimatorFormState = Map.from(initialEstimatorFormState);

  DateEntry dateEntry;

  void initValues() {
    dateEntry = null;
    estimatorFormState = Map.from(initialEstimatorFormState);
  }

  void setAuctionDetails(AuctionDetail auctionDetails) {
    issues = auctionDetails.getIssues();
  }

  Future<List<ItemType>> loadItemTypes() async {
    var response = await providerService.getItemTypes();
    itemTypes = response;
    notifyListeners();
    return response;
  }

  Future<List<ProviderItem>> loadProviderItems(int serviceProviderId,
      IssueItemQuery query) async {
    var response = await providerService.getProviderItems(
        serviceProviderId, query.toJson());
    providerItems = response;
    notifyListeners();
    return response;
  }

  Future<List<ServiceProviderTimetable>> loadServiceProviderSchedule(
      int providerId, String startDate, String endDate) async {
    this.serviceProviderTimetable =
    await providerService.getServiceProviderTimetables(
        providerId, startDate, endDate);
    notifyListeners();
    return this.serviceProviderTimetable;
  }

  addRequestToIssue(Issue issue) {
    var issueItem = IssueItem(
      type: estimatorFormState['type'],
      code: estimatorFormState['code'].code,
      name: estimatorFormState['name'].name,
      quantity: estimatorFormState['quantity'],
      price: estimatorFormState['price'],
      priceVAT: estimatorFormState['priceVAT'],
    );

    for (Issue temp in issues) {
      if (temp.id == issue.id) {
        issueItem.issueId = issueItem.issueId;
        temp.items.add(issueItem);
      }
    }
  }

  removeIssueItem(Issue issue, IssueItem issueItem) {
    issue.items.remove(issueItem);
  }

  bool isValid() {
    bool valid = true;

    for (Issue issue in issues) {
      if (issue.items.length == 0) {
        valid = false;
        break;
      }
    }

    valid = dateEntry != null;

    return valid;
  }

  Map<String, dynamic> createBidContent() {
    Map<String, dynamic> map = new Map();
    map['proposedDate'] = this.dateEntry != null ? DateUtils.stringFromDate(
        this.dateEntry.dateTime, 'dd/MM/yyyy HH:mm') : '';

    List<dynamic> issuesList = [];

    for (Issue issue in issues) {
      issuesList.add(issue.toCreateJson());
    }

    map['estimateIssues'] = issuesList;
    return map;
  }
}
