import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
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
      this.selected});

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
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _checkMarkContainer(context),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 4, bottom: 4, right: 4, left: 10),
                          child: Text(
                            issueRecommendation.name,
                            style: TextHelper.customTextStyle(
                                null, black_text, FontWeight.bold, 14),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: FlatButton(
                              padding: EdgeInsets.all(4),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
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
                      ),
                    ],
                  ),
                  if (estimatorMode == EstimatorMode.Client ||
                      estimatorMode == EstimatorMode.ClientAccept)
                    _priceContainer(context)
                ],
              ),
            ),
            _issuesContainer(),
          ],
        ));
  }

  _checkMarkContainer(BuildContext context) {
    if (estimatorMode == EstimatorMode.ReadOnly ||
        estimatorMode == EstimatorMode.Create ||
        estimatorMode == EstimatorMode.CreateFinal ||
        estimatorMode == EstimatorMode.ClientAccept ||
        estimatorMode == EstimatorMode.CreatePart ||
        estimatorMode == EstimatorMode.Edit) {
      return Container();
    }

    return Expanded(
      child: Align(
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
              this.selectIssueSection(issueRecommendation);
            },
          ),
        ),
      ),
    );
  }

  _priceContainer(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 6, bottom: 6, right: 10),
        child: Text(
          '${S.of(context).estimator_total}: ${issueRecommendation.totalCost()} RON',
          style: TextHelper.customTextStyle(null, red, FontWeight.bold, 16),
        ),
      ),
    );
  }

  _issuesContainer() {
    if (issueRecommendation.expanded) {
      return Container(
        margin: EdgeInsets.only(top: 4),
        child: WorkEstimateSectionItemsWidget(
            issueRecommendation: issueRecommendation,
            addIssueItem: addIssueItem,
            removeIssueItem: removeIssueItem,
            estimatorMode: estimatorMode),
      );
    } else {
      return Container();
    }
  }
}
