import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/custom-show-dialog.widget.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkEstimateIssueDetailsWidget extends StatelessWidget {
  final IssueItem issueItem;
  final Function importItem;

  WorkEstimateIssueDetailsWidget({this.issueItem, this.importItem});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              issueItem.name,
              style: TextHelper.customTextStyle(null, red, FontWeight.bold, 20),
            ),
            _infoWidget(S
                .of(context)
                .import_item_imported_title, issueItem?.provider?.name),
            // TODO - no status for items to be imported
            _infoWidget(S
                .of(context)
                .import_item_status_title, 'New'),
            _infoWidget(S
                .of(context)
                .import_item_type_title, S
                .of(context)
                .estimator_product),
            _infoWidget(S
                .of(context)
                .import_item_code_title, issueItem?.code),
            _infoWidget(S
                .of(context)
                .import_item_name_title, issueItem?.name),
            _infoWidget(S
                .of(context)
                .import_item_warranty_title, issueItem?.warranty.toString()),
            _infoWidget(S
                .of(context)
                .import_item_price_title, issueItem?.price.toString()),
            _infoWidget(S
                .of(context)
                .import_item_price_w_vta_title,
                '${issueItem?.price + issueItem?.priceVAT}'),
            _infoWidget(S
                .of(context)
                .import_item_availability_title, DateUtils.stringFromDate(
                issueItem?.availableFrom, 'EEEE, dd MMM. yyyy')),
            _buttonsWidget(context),
          ],
        ),
      ),
    );
  }

  _infoWidget(String leftString, String rightString) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 1,
            child: Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 4),
                child: Text(
                  leftString,
                  textAlign: TextAlign.right,
                  style: TextHelper.customTextStyle(
                      null, gray3, FontWeight.bold, 14),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 4),
                child: Text(
                  rightString,
                  textAlign: TextAlign.left,
                  style: TextHelper.customTextStyle(null, gray3, null, 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buttonsWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              S
                  .of(context)
                  .general_back
                  .toUpperCase(),
              style: TextHelper.customTextStyle(
                  null, gray3, FontWeight.bold, 16),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              importItem(issueItem);
            },
            child: Text(
              S
                  .of(context)
                  .import_item_import_title
                  .toUpperCase(),
              style: TextHelper.customTextStyle(
                  null, green, FontWeight.bold, 16),
            ),
          )
        ],
      ),
    );
  }
}
