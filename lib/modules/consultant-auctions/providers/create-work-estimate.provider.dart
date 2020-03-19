import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:enginizer_flutter/modules/appointments/services/provider.service.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item-query.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-refactor.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-section.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/item-type.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/request/work-estimate-request-refactor.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/request/work-estimate-request.model.dart';
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

  List<ItemType> itemTypes = [];
  List<ProviderItem> providerItems = [];
  List<ServiceProviderTimetable> serviceProviderTimetable = [];
  WorkEstimateRequest workEstimateRequest;
  WorkEstimateRequestRefactor workEstimateRequestRefactor;

  Map<String, dynamic> estimatorFormState = Map.from(initialEstimatorFormState);

  void initValues() {
    estimatorFormState = Map.from(initialEstimatorFormState);
  }

  void refreshValues() {
    initValues();
    workEstimateRequest = WorkEstimateRequest();
    workEstimateRequestRefactor = WorkEstimateRequestRefactor();
  }

  void setIssues(List<Issue> issues) {
    for (Issue issue in issues) {
      issue.clearItems();
    }
    workEstimateRequest.issues = issues;

    List<IssueRefactor> list = new List();

    for (Issue issue in issues) {
      list.add(issue.toRefactor());
    }
    workEstimateRequestRefactor.issues = list;
  }

  Future<List<ItemType>> loadItemTypes() async {
    var response = await providerService.getItemTypes();
    itemTypes = response;
    notifyListeners();
    return response;
  }

  Future<List<ProviderItem>> loadProviderItems(
      int serviceProviderId, IssueItemQuery query) async {
    var response = await providerService.getProviderItems(
        serviceProviderId, query.toJson());
    providerItems = response;
    notifyListeners();
    return response;
  }

  Future<List<ServiceProviderTimetable>> loadServiceProviderSchedule(
      int providerId, String startDate, String endDate) async {
    this.serviceProviderTimetable = await providerService
        .getServiceProviderTimetables(providerId, startDate, endDate);
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

    for (Issue temp in workEstimateRequest.issues) {
      if (temp.id == issue.id) {
        issueItem.issueId = issueItem.issueId;
        temp.items.add(issueItem);
      }
    }
  }

  addRequestToIssueSection(
      IssueRefactor issueRefactor, IssueSection issueSection) {
    var issueItem = IssueItem(
      type: estimatorFormState['type'],
      code: estimatorFormState['code'].code,
      name: estimatorFormState['name'].name,
      quantity: estimatorFormState['quantity'],
      price: estimatorFormState['price'],
      priceVAT: estimatorFormState['priceVAT'],
    );

    for (IssueRefactor temp in workEstimateRequestRefactor.issues) {
      if (temp == issueRefactor) {
        List<IssueSection> sections = temp.sections;

        for (IssueSection tempIssueSection in sections) {
          if (tempIssueSection == issueSection) {
            tempIssueSection.items.add(issueItem);
            break;
          }
        }
        break;
      }
    }
  }

  removeIssueItem(Issue issue, IssueItem issueItem) {
    issue.items.remove(issueItem);
  }

  removeIssueRefactorItem(IssueRefactor issueRefactor,
      IssueSection issueSection, IssueItem issueItem) {
    for (IssueRefactor temp in workEstimateRequestRefactor.issues) {
      if (temp == issueRefactor) {
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

  selectIssueSection(IssueRefactor issueRefactor, IssueSection issueSection) {
    for (IssueRefactor temp in workEstimateRequestRefactor.issues) {
      if (temp == issueRefactor) {
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
}
