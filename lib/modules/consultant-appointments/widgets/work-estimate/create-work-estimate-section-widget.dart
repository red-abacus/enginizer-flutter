import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-section.model.dart';
import 'package:enginizer_flutter/modules/consultant-appointments/widgets/work-estimate/create-work-estimate-section-items.widget.dart';
import 'package:enginizer_flutter/modules/shared/widgets/alert-text-form-widget.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CreateWorkEstimateSectionWidget extends StatelessWidget {
  final IssueSection issueSection;

  final Function addSectionName;
  final Function expandSection;
  final Function addIssueItem;
  final Function removeIssueItem;

  CreateWorkEstimateSectionWidget(
      {this.issueSection,
      this.addSectionName,
      this.expandSection,
      this.addIssueItem,
      this.removeIssueItem});

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
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 4, bottom: 4, right: 4, left: 10),
                      child: InkWell(
                        onTap: () => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertTextFormWidget(
                                title: S.of(context).estimator_add_section_name,
                                placeholder: issueSection.isNew
                                    ? S.of(context).estimator_section_name
                                    : issueSection.name,
                                buttonName: S.of(context).general_add,
                                addTextFunction: _addSectionName,
                              );
                            },
                          )
                        },
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

  _issuesContainer() {
    if (issueSection.expanded) {
      return Container(
        margin: EdgeInsets.only(top: 4),
        child: CreateWorkEstimateSectionItemsWidget(
            issueSection: issueSection,
            addIssueItem: addIssueItem,
            removeIssueItem: removeIssueItem),
      );
    } else {
      return Container();
    }
  }

  _addSectionName(String name) {
    this.addSectionName(name, this.issueSection);
  }
}
