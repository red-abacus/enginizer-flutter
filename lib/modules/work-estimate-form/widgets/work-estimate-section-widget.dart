import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/models/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-section.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/work-estimate-form/widgets/work-estimate-section-items.widget.dart';
import 'package:app/modules/shared/widgets/alert-text-form-widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WorkEstimateSectionWidget extends StatelessWidget {
  final IssueSection issueSection;
  final Issue issue;

  final Function expandSection;
  final Function addIssueItem;
  final Function removeIssueItem;
  final Function selectIssueSection;
  final Function showSectionName;
  final EstimatorMode estimatorMode;
  final GlobalKey<ScaffoldState> scaffoldKey;

  WorkEstimateSectionWidget(
      {this.issue,
      this.issueSection,
      this.expandSection,
      this.addIssueItem,
      this.removeIssueItem,
      this.selectIssueSection,
      this.showSectionName,
      this.estimatorMode,
      this.scaffoldKey});

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
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 4, bottom: 4, right: 4, left: 10),
                      child: InkWell(
                        onTap: () =>
                            {showSectionName(this.issue, this.issueSection)},
                        child: Text(
                          issueSection.isNew
                              ? S.of(context).estimator_add_section_name
                              : issueSection.name,
                          style: TextHelper.customTextStyle(
                              null, black_text, FontWeight.bold, 14),
                        ),
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
                            this.issueSection.expanded
                                ? 'assets/images/icons/down_arrow.svg'
                                : 'assets/images/icons/up_arrow.svg',
                            semanticsLabel: 'Up Arrow',
                            height: 14,
                            width: 14,
                          ),
                          onPressed: () {
                            this.expandSection(this.issueSection);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _issuesContainer(),
          ],
        ));
  }

  _checkMarkContainer(BuildContext context) {
    if (estimatorMode == EstimatorMode.ReadOnly) {
      return Container();
    }

    return issueSection.isNew
        ? Container()
        : Expanded(
            child: Align(
              child: Container(
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: SvgPicture.asset(
                    this.issueSection.selected
                        ? 'assets/images/icons/check_box.svg'
                        : 'assets/images/icons/check_box_empty.svg',
                    semanticsLabel: 'Up Arrow',
                    color: Theme.of(context).primaryColor,
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () {
                    this.selectIssueSection(issueSection);
                  },
                ),
              ),
            ),
          );
  }

  _issuesContainer() {
    if (issueSection.expanded) {
      return Container(
        margin: EdgeInsets.only(top: 4),
        child: WorkEstimateSectionItemsWidget(
            issueSection: issueSection,
            addIssueItem: addIssueItem,
            removeIssueItem: removeIssueItem,
            estimatorMode: estimatorMode,
            scaffoldKey: scaffoldKey),
      );
    } else {
      return Container();
    }
  }
}
