import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/models/issue-section.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'work-estimate-add-issue-modal.widget.dart';
import 'work-estimate-issue.widget.dart';

final createWorkEstimateAddIssueKey =
    new GlobalKey<WorkEstimateAddIssueModalWidgetState>();

class WorkEstimateSectionItemsWidget extends StatelessWidget {
  final IssueSection issueSection;
  final Function addIssueItem;
  final Function removeIssueItem;
  final EstimatorMode estimatorMode;

  WorkEstimateSectionItemsWidget(
      {this.issueSection,
      this.addIssueItem,
      this.removeIssueItem,
      this.estimatorMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _issuesContainer(),
        _addContainer(context),
      ],
    );
  }

  _issuesContainer() {
    return issueSection.items.length == 0
        ? Container()
        : Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                for (IssueItem issueItem in issueSection.items)
                  WorkEstimateIssueWidget(
                      issueItem: issueItem,
                      removeIssueItem: _removeIssueItem,
                      estimatorMode: estimatorMode),
              ],
            ),
          );
  }

  _addContainer(BuildContext context) {
    return estimatorMode == EstimatorMode.ReadOnly
        ? Container()
        : InkWell(
            onTap: () => _openAddIssueModal(context),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: new BorderRadius.all(Radius.circular(15))),
                  width: 30,
                  height: 30,
                  child: IconTheme(
                    data: new IconThemeData(color: Colors.white),
                    child: new Icon(Icons.add),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    S.of(context).estimator_add_new_product,
                    style: TextHelper.customTextStyle(
                        null, black_text, FontWeight.normal, 14),
                  ),
                ),
              ],
            ),
          );
  }

  _openAddIssueModal(BuildContext context) {
    WorkEstimateProvider provider = Provider.of<WorkEstimateProvider>(context);
    provider.refreshForm();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return WorkEstimateAddIssueModalWidget(
                key: createWorkEstimateAddIssueKey,
                addIssueItem: this.addIssueItem,
                issueSection: this.issueSection);
          });
        });
  }

  _removeIssueItem(IssueItem issueItem) {
    removeIssueItem(issueSection, issueItem);
  }
}
