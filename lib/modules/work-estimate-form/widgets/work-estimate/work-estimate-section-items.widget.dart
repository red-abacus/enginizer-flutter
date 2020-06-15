import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/work-estimate-form/providers/work-estimate.provider.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/screens/work-estimate-import-modal.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/work-estimate-add-issue-modal.dart';
import 'work-estimate-issue.widget.dart';

final createWorkEstimateAddIssueKey =
    new GlobalKey<WorkEstimateAddIssueModalState>();

class WorkEstimateSectionItemsWidget extends StatelessWidget {
  final Issue issue;
  final IssueRecommendation issueRecommendation;
  final Function addIssueItem;
  final Function removeIssueItem;
  final EstimatorMode estimatorMode;
  final Function editIssueItem;

  WorkEstimateSectionItemsWidget(
      {this.issue,
      this.issueRecommendation,
      this.addIssueItem,
      this.removeIssueItem,
      this.estimatorMode,
      this.editIssueItem});

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
    return issueRecommendation.items.length == 0
        ? Container()
        : Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                for (IssueItem issueItem in issueRecommendation.items)
                  WorkEstimateIssueWidget(
                      issueItem: issueItem,
                      removeIssueItem: _removeIssueItem,
                      editIssueItem: _editIssueItem,
                      estimatorMode: estimatorMode),
              ],
            ),
          );
  }

  _addContainer(BuildContext context) {
    return estimatorMode == EstimatorMode.ReadOnly ||
            estimatorMode == EstimatorMode.Client ||
            estimatorMode == EstimatorMode.ClientAccept
        ? Container()
        : Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () => this._openAddIssueModal(context),
                  child: Container(
                    height: 36,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(5.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        color: gray2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              S.of(context).estimator_add_new_product,
                              style: TextHelper.customTextStyle(
                                  null, Colors.white, FontWeight.normal, 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (estimatorMode == EstimatorMode.Edit)
                  InkWell(
                    onTap: () => this._openImportIssueModal(context),
                    child: Container(
                      height: 36,
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(5.0),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          color: gray2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                S.of(context).estimator_import_product,
                                style: TextHelper.customTextStyle(
                                    null, Colors.white, FontWeight.normal, 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
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
            return WorkEstimateAddIssueModal(
                key: createWorkEstimateAddIssueKey,
                addIssueItem: addIssueItem,
                issueRecommendation: this.issueRecommendation);
          });
        });
  }

  _openImportIssueModal(BuildContext context) {
    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return WorkEstimateImportModal(
                workEstimateId:
                    Provider.of<WorkEstimateProvider>(context).workEstimateId,
                issue: this.issue,
                issueRecommendation: this.issueRecommendation);
          });
        });
  }

  _removeIssueItem(IssueItem issueItem) {
    removeIssueItem(issueRecommendation, issueItem);
  }

  _editIssueItem(IssueItem issueItem) {
    editIssueItem(issueRecommendation, issueItem);
  }
}
