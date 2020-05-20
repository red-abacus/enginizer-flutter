import 'package:app/generated/l10n.dart';
import 'package:app/modules/shared/widgets/alert-warning-dialog.dart';
import 'package:app/modules/shared/widgets/custom-show-dialog.widget.dart';
import 'package:app/modules/shared/widgets/custom-text-form-field.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkEstimateIssueEditWidget extends StatefulWidget {
  final IssueItem issueItem;
  final Function editItem;

  Map<String, dynamic> formState = {
    'quantity': '0',
    'addition': '0',
  };

  WorkEstimateIssueEditWidget({this.issueItem, this.editItem}) {
    formState['quantity'] = this.issueItem.quantity != null ? this.issueItem.quantity.toString() : '0';
    formState['addition'] = this.issueItem.addition != null ? this.issueItem.addition.toString() : '0';
  }

  @override
  _WorkEstimateIssueEditWidgetState createState() =>
      _WorkEstimateIssueEditWidgetState();
}

class _WorkEstimateIssueEditWidgetState
    extends State<WorkEstimateIssueEditWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new CustomAlertDialog(
      content: new Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  widget.issueItem.name,
                  style: TextHelper.customTextStyle(
                      null, red, FontWeight.bold, 20),
                ),
                _infoWidget(S.of(context).import_item_type_title,
                    S.of(context).estimator_product),
                _infoWidget(S.of(context).import_item_code_title,
                    widget.issueItem?.code),
                _infoWidget(S.of(context).import_item_name_title,
                    widget.issueItem?.name),
                _infoWidget(S.of(context).import_item_warranty_title,
                    widget.issueItem?.warranty.toString()),
                _infoWidget(S.of(context).import_item_price_title,
                    widget.issueItem?.price.toString()),
                _infoWidget(S.of(context).import_item_price_w_vta_title,
                    '${widget.issueItem?.price + widget.issueItem?.priceVAT}'),
                _quantityWidget(S.of(context).import_item_quantity_title),
                _additionWidget(S.of(context).import_item_addition_title),
                _buttonsWidget(context),
              ],
            ),
          ),
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
                    null, gray3, FontWeight.bold, 14),
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
                style: TextHelper.customTextStyle(null, gray3, null, 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _quantityWidget(String leftString) {
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
                    null, gray3, FontWeight.bold, 14),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 4),
              child: CustomTextFormField(
                textInputType: TextInputType.number,
                listener: (value) {
                  widget.formState['quantity'] = value;
                },
                currentValue: widget.formState['quantity'],
                errorText: '',
                validate: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _additionWidget(String leftString) {
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
                    null, gray3, FontWeight.bold, 14),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 4),
              child: CustomTextFormField(
                textInputType: TextInputType.number,
                listener: (value) {
                  widget.formState['addition'] = value;
                },
                currentValue: widget.formState['addition'],
                errorText: '',
                validate: true,
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
                  TextHelper.customTextStyle(null, gray3, FontWeight.bold, 16),
            ),
          ),
          FlatButton(
            onPressed: () {
              _editItem();
            },
            child: Text(
              S.of(context).general_edit.toUpperCase(),
              style:
                  TextHelper.customTextStyle(null, green, FontWeight.bold, 16),
            ),
          )
        ],
      ),
    );
  }

  _editItem() {
    if (_formKey.currentState.validate()) {
      int quantity = int.parse(widget.formState['quantity']);

      if (quantity != null) {
        if (quantity == 0) {
          AlertWarningDialog.showAlertDialog(
              context,
              S.of(context).general_warning,
              S.of(context).import_item_quantity_alert);
        } else {
          Navigator.pop(context);
          widget.issueItem.quantity = quantity;
          widget.issueItem.addition = double.parse(widget.formState['addition']);

          widget.editItem(widget.issueItem);
        }
      }
    }
  }
}
