import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-section.model.dart';
import 'package:enginizer_flutter/modules/consultant-auctions/providers/create-work-estimate.provider.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'create-work-estimate-add-issue-modal.widget.dart';
import 'create-work-estimate-issue.widget.dart';

final createWorkEstimateAddIssueKey =
    new GlobalKey<CreateWorkEstimateAddIssueModalWidgetState>();

class CreateWorkEstimateSectionItemsWidget extends StatelessWidget {
  final IssueSection issueSection;
  final Function addIssueItem;
  final Function removeIssueItem;

  CreateWorkEstimateSectionItemsWidget({this.issueSection, this.addIssueItem, this.removeIssueItem});

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
                  CreateWorkEstimateIssueWidget(
                      issueItem: issueItem,
                      removeIssueItem: _removeIssueItem),
              ],
            ),
          );
  }

  _addContainer(BuildContext context) {
    return InkWell(
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
    CreateWorkEstimateProvider provider = Provider.of<CreateWorkEstimateProvider>(context);
    provider.initValues();

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return CreateWorkEstimateAddIssueModalWidget(
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
