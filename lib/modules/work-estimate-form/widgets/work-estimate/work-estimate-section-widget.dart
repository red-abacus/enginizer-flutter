import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/enums/issue-recommendation-status.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate/work-estimate-section-items.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WorkEstimateSectionWidget extends StatelessWidget {
  final IssueRecommendation issueRecommendation;
  final Issue issue;

  final Function expandSection;
  final Function addIssueItem;
  final Function removeIssueItem;
  final Function editIssueItem;
  final Function selectIssueSection;
  final Function showSectionName;
  final EstimatorMode estimatorMode;
  final bool selected;

  WorkEstimateSectionWidget(
      {this.issue,
      this.issueRecommendation,
      this.expandSection,
      this.addIssueItem,
      this.removeIssueItem,
      this.selectIssueSection,
      this.showSectionName,
      this.estimatorMode,
      this.selected,
      this.editIssueItem});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _sectionTextFormField(context),
      ],
    );
  }

  _sectionTextFormField(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Column(
          children: <Widget>[
            Container(
              color: gray_10,
              child: Row(
                children: <Widget>[
                  _checkMarkContainer(context),
                  _nameContainer(context),
                  _arrowContainer(),
                ],
              ),
            ),
            _issuesContainer(),
            _priceContainer(context),
          ],
        ));
  }

  _nameContainer(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        margin: EdgeInsets.only(top: 4, bottom: 4, right: 4, left: 10),
        child: Text(
          issueRecommendation.name,
          style: TextHelper.customTextStyle(
              color: black_text, weight: FontWeight.bold),
        ),
      ),
    );
  }

  _arrowContainer() {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          margin: EdgeInsets.only(right: 10),
          child: FlatButton(
            padding: EdgeInsets.all(4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: SvgPicture.asset(
              this.issueRecommendation.expanded
                  ? 'assets/images/icons/down_arrow.svg'
                  : 'assets/images/icons/up_arrow.svg',
              semanticsLabel: 'Up Arrow',
              height: 14,
              width: 14,
            ),
            onPressed: () {
              this.expandSection(this.issueRecommendation);
            },
          ),
        ),
      ),
    );
  }

  _checkMarkContainer(BuildContext context) {
    double alpha =
        issueRecommendation.status == IssueRecommendationStatus.New ? 1.0 : 0.4;

    switch (estimatorMode) {
      case EstimatorMode.Client:
        return Expanded(
          child: Align(
            child: Opacity(
              opacity: alpha,
              child: Container(
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: SvgPicture.asset(
                    this.selected
                        ? 'assets/images/icons/check_box.svg'
                        : 'assets/images/icons/check_box_empty.svg',
                    semanticsLabel: 'Up Arrow',
                    color: Theme.of(context).primaryColor,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () {
                    if (issueRecommendation.status ==
                        IssueRecommendationStatus.New) {
                      this.selectIssueSection(issueRecommendation);
                    }
                  },
                ),
              ),
            ),
          ),
        );
        break;
      default:
        return Container();
    }
  }

  _priceContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
      color: gray_10,
      child: Row(
        children: [
          Text(
            '${S.of(context).estimator_total}: ${issueRecommendation.totalCost().toStringAsFixed(2)} ${S.of(context).general_currency}',
            style: TextHelper.customTextStyle(
                color: red, weight: FontWeight.bold, size: 16),
          )
        ],
      ),
    );
  }

  _issuesContainer() {
    if (issueRecommendation.expanded) {
      return Container(
        margin: EdgeInsets.only(top: 4),
        child: WorkEstimateSectionItemsWidget(
            issue: issue,
            issueRecommendation: issueRecommendation,
            addIssueItem: addIssueItem,
            removeIssueItem: removeIssueItem,
            editIssueItem: editIssueItem,
            estimatorMode: estimatorMode),
      );
    } else {
      return Container();
    }
  }
}
