import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-refactor.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-section.model.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/widgets/work-estimate/create-work-estimate-section-widget.dart';
import 'package:flutter/cupertino.dart';

class CreateWorkEstimateSectionsWidget extends StatefulWidget {
  final IssueRefactor issueRefactor;

  Function setSectionName;
  Function expandSection;
  Function addIssueItem;
  Function removeIssueItem;

  CreateWorkEstimateSectionsWidget(
      {this.issueRefactor,
      this.setSectionName,
      this.expandSection,
      this.addIssueItem,
      this.removeIssueItem});

  @override
  _CreateWorkEstimateSectionsWidgetState createState() =>
      _CreateWorkEstimateSectionsWidgetState();
}

class _CreateWorkEstimateSectionsWidgetState
    extends State<CreateWorkEstimateSectionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (IssueSection section in widget.issueRefactor.sections)
            CreateWorkEstimateSectionWidget(
                issueSection: section,
                addSectionName: _setSectionName,
                expandSection: _expandSection,
                addIssueItem: _addIssueItem,
                removeIssueItem: _removeIssueItem)
        ],
      ),
    );
  }

  _setSectionName(String name, IssueSection issueSection) {
    widget.setSectionName(widget.issueRefactor, name, issueSection);
  }

  _expandSection(IssueSection issueSection) {
    widget.expandSection(widget.issueRefactor, issueSection);
  }

  _addIssueItem(IssueSection issueSection) {
    widget.addIssueItem(widget.issueRefactor, issueSection);
  }

  _removeIssueItem(IssueSection issueSection, IssueItem issueItem) {
    widget.removeIssueItem(widget.issueRefactor, issueSection, issueItem);
  }
}
