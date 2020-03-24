import 'package:enginizer_flutter/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue-section.model.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue.model.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/widgets/work-estimate-section-widget.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimateSectionsWidget extends StatefulWidget {
  final Issue issue;
  final EstimatorMode estimatorMode;
  final Function setSectionName;
  final Function expandSection;
  final Function addIssueItem;
  final Function removeIssueItem;
  final Function selectIssueSection;

  WorkEstimateSectionsWidget(
      {this.issue,
      this.setSectionName,
      this.expandSection,
      this.addIssueItem,
      this.removeIssueItem,
      this.selectIssueSection,
      this.estimatorMode});

  @override
  _WorkEstimateSectionsWidgetState createState() =>
      _WorkEstimateSectionsWidgetState();
}

class _WorkEstimateSectionsWidgetState
    extends State<WorkEstimateSectionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (IssueSection section in widget.issue.sections)
            WorkEstimateSectionWidget(
                issueSection: section,
                addSectionName: _setSectionName,
                expandSection: _expandSection,
                addIssueItem: _addIssueItem,
                removeIssueItem: _removeIssueItem,
                selectIssueSection: _selectIssueSection,
                estimatorMode: widget.estimatorMode)
        ],
      ),
    );
  }

  _setSectionName(String name, IssueSection issueSection) {
    widget.setSectionName(widget.issue, name, issueSection);
  }

  _expandSection(IssueSection issueSection) {
    widget.expandSection(widget.issue, issueSection);
  }

  _addIssueItem(IssueSection issueSection) {
    widget.addIssueItem(widget.issue, issueSection);
  }

  _removeIssueItem(IssueSection issueSection, IssueItem issueItem) {
    widget.removeIssueItem(widget.issue, issueSection, issueItem);
  }

  _selectIssueSection(IssueSection issueSection) {
    widget.selectIssueSection(widget.issue, issueSection);
  }
}
