import 'package:app/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate-section-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkEstimateSectionsWidget extends StatefulWidget {
  final Issue issue;
  final EstimatorMode estimatorMode;
  final Function expandSection;
  final Function addIssueItem;
  final Function removeIssueItem;
  final Function selectIssueSection;
  final Function showSectionName;

  WorkEstimateSectionsWidget(
      {this.issue,
      this.expandSection,
      this.addIssueItem,
      this.removeIssueItem,
      this.selectIssueSection,
      this.showSectionName,
      this.estimatorMode});

  @override
  _WorkEstimateSectionsWidgetState createState() =>
      _WorkEstimateSectionsWidgetState();
}

class _WorkEstimateSectionsWidgetState
    extends State<WorkEstimateSectionsWidget> {
  // TODO - when service provider creates a new estimate, the items are not saved.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (IssueRecommendation recommendation in widget.issue.recommendations)
            WorkEstimateSectionWidget(
                issue: widget.issue,
                issueRecommendation: recommendation,
                expandSection: _expandSection,
                addIssueItem: _addIssueItem,
                removeIssueItem: _removeIssueItem,
                selectIssueSection: _selectIssueSection,
                showSectionName: widget.showSectionName,
                estimatorMode: widget.estimatorMode)
        ],
      ),
    );
  }

  _expandSection(IssueRecommendation issueRecommendation) {
    widget.expandSection(widget.issue, issueRecommendation);
  }

  _addIssueItem(IssueRecommendation issueRecommendation) {
    widget.addIssueItem(widget.issue, issueRecommendation);
  }

  _removeIssueItem(IssueRecommendation issueRecommendation, IssueItem issueItem) {
    widget.removeIssueItem(widget.issue, issueRecommendation, issueItem);
  }

  _selectIssueSection(IssueRecommendation issueRecommendation) {
    widget.selectIssueSection(widget.issue, issueRecommendation);
  }
}
