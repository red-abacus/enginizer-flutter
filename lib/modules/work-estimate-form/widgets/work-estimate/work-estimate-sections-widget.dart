import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate/work-estimate-section-widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkEstimateSectionsWidget extends StatefulWidget {
  final Issue issue;
  final EstimatorMode estimatorMode;
  final Function expandSection;
  final Function addIssueItem;
  final Function removeIssueItem;
  final Function selectIssueSection;
  final Function editIssueItem;

  WorkEstimateSectionsWidget(
      {this.issue,
      this.expandSection,
      this.addIssueItem,
      this.removeIssueItem,
      this.selectIssueSection,
      this.estimatorMode,
      this.editIssueItem});

  @override
  _WorkEstimateSectionsWidgetState createState() =>
      _WorkEstimateSectionsWidgetState();
}

class _WorkEstimateSectionsWidgetState
    extends State<WorkEstimateSectionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          for (IssueRecommendation recommendation in widget.issue.recommendations)
            WorkEstimateSectionWidget(
                issue: widget.issue,
                issueRecommendation: recommendation,
                expandSection: _expandSection,
                addIssueItem: _addIssueItem,
                editIssueItem: _editIssueItem,
                removeIssueItem: _removeIssueItem,
                selectIssueSection: _selectIssueSection,
                estimatorMode: widget.estimatorMode,
                selected: Provider.of<WorkEstimateProvider>(context)
                    .selectedRecommendations
                    .contains(recommendation)),
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

  _removeIssueItem(
      IssueRecommendation issueRecommendation, IssueItem issueItem) {
    widget.removeIssueItem(widget.issue, issueRecommendation, issueItem);
  }

  _selectIssueSection(IssueRecommendation issueRecommendation) {
    widget.selectIssueSection(widget.issue, issueRecommendation);
  }

  _editIssueItem(IssueRecommendation issueRecommendation, IssueItem issueItem) {
    widget.editIssueItem(widget.issue, issueRecommendation, issueItem);
  }
}
