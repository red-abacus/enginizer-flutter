import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/work-estimate-details.model.dart';
import 'package:enginizer_flutter/modules/auctions/services/work-estimates.service.dart';
import 'package:flutter/foundation.dart';

class WorkEstimatesProvider with ChangeNotifier {
  static final Map<String, dynamic> initialEstimatorFormState = {
    'type': null,
    'code': null,
    'name': null,
    'quantity': '',
    'price': '',
    'priceVAT': ''
  };

  WorkEstimatesService workEstimatesService = inject<WorkEstimatesService>();

  int workEstimateId;
  ServiceProvider serviceProvider;
  WorkEstimateDetails workEstimateDetails;

  Map<String, dynamic> estimatorFormState = Map.from(initialEstimatorFormState);

  void initValues() {
    estimatorFormState = Map.from(initialEstimatorFormState);
  }

  Future<WorkEstimateDetails> getWorkEstimateDetails(int workEstimateId) async {
    workEstimateDetails =
        await this.workEstimatesService.getWorkEstimateDetails(workEstimateId);
    notifyListeners();
    return workEstimateDetails;
  }

  Future<Issue> addWorkEstimateItem(Issue issue) async {
    var newIssue = await this
        .workEstimatesService.addWorkEstimateItem(workEstimateDetails.id, issue);
    var issueIndex = workEstimateDetails.issues
        .indexWhere((estimateIssue) => estimateIssue.id == newIssue.id);
    workEstimateDetails.issues[issueIndex] = newIssue;
    notifyListeners();
    return newIssue;
  }

  Future<bool> deleteWorkEstimateItem(Issue issue, IssueItem issueItem) async {
    var estimateItemDeleted = await this
        .workEstimatesService.deleteWorkEstimateItem(workEstimateDetails.id, issueItem.id);
    if (estimateItemDeleted) {
      var issueIndex = workEstimateDetails.issues
          .indexWhere((estimateIssue) => estimateIssue.id == issue.id);
      var estimateItemIndex = workEstimateDetails.issues[issueIndex].items
          .indexWhere((estimateIssueItem) => estimateIssueItem.id == issueItem.id);
      workEstimateDetails.issues[issueIndex].items.removeAt(estimateItemIndex);
    }
    notifyListeners();
    return estimateItemDeleted;
  }

  Issue estimateIssueRequest(Issue issue) {
    Issue estimateIssueRequest = Issue();

    estimateIssueRequest.id = issue.id;

    estimateIssueRequest.items = [];

    var issueItem = IssueItem(
      type: estimatorFormState['type'],
      code: estimatorFormState['code'].code,
      name: estimatorFormState['name'].name,
      quantity: estimatorFormState['quantity'],
      price: estimatorFormState['price'],
      priceVAT: estimatorFormState['priceVAT'],
    );

    estimateIssueRequest.items.add(issueItem);

    return estimateIssueRequest;
  }
}
