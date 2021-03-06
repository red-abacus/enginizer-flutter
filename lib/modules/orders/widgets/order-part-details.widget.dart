import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/custom-show-dialog.widget.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderPartDetails extends StatelessWidget {
  final IssueItem issueItem;

  OrderPartDetails({this.issueItem});

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              issueItem.name,
              style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 20),
            ),
            _infoWidget(S.of(context).import_item_type_title,
                S.of(context).estimator_product),
            _infoWidget(S.of(context).import_item_code_title, issueItem?.code),
            _infoWidget(S.of(context).import_item_name_title, issueItem?.name),
            _infoWidget(S.of(context).import_item_warranty_title,
                issueItem?.warranty.toString()),
            _infoWidget(S.of(context).import_item_price_title,
                issueItem?.price.toString()),
            _infoWidget(S.of(context).import_item_price_w_vta_title,
                '${issueItem?.price + issueItem?.priceVAT}'),
            _infoWidget(S.of(context).import_item_quantity_title,
                '${issueItem?.quantity}'),
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
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 4),
              child: Text(
                '$leftString:',
                textAlign: TextAlign.right,
                style: TextHelper.customTextStyle(
                    color: gray3, weight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 4),
              child: Text(
                rightString,
                textAlign: TextAlign.left,
                style: TextHelper.customTextStyle(color: gray3),
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
              S.of(context).general_back.toUpperCase(),
              style:
                  TextHelper.customTextStyle(color: gray3, weight: FontWeight.bold, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
