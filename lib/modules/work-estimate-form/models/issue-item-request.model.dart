import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';

class IssueItemRequest {
  int issueId = 0;
  int recommendationId = 0;
  IssueItem issueItem;

  IssueItemRequest(
      {this.issueId,
        this.recommendationId,
        this.issueItem});

  Map<String, dynamic> toCreateJson() => {
    'issueId': this.issueId,
    'recommendationId': this.recommendationId,
    'items': [issueItem.toCreateJson()]
  };
}