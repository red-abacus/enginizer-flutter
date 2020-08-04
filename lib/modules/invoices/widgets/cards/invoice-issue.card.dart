import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvoiceIssueCard extends StatelessWidget {
  final IssueItem issueItem;

  InvoiceIssueCard({this.issueItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        _nameContainer(context),
                        _typeContainer(context),
                        _guaranteeContainer(context),
                        _quantityContainer(context),
                        _additionContainer(context),
                        _priceContainer(context),
                        _totalContainer(context),
                      ],
                    ),
                  ),
                ],
              ),
              Opacity(
                opacity: 0.5,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 1,
                  color: red,
                ),
              )
            ],
          )),
    );
  }

  _nameContainer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Text(
            '${issueItem.name} (${issueItem.code})',
            style: TextHelper.customTextStyle(
                color: black_text, weight: FontWeight.bold, size: 16),
          ),
        ),
      ],
    );
  }

  _typeContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Text(
              '${S.of(context).estimator_type}: ${_translateType(context, issueItem.type.name)}',
              style: TextHelper.customTextStyle(
                  color: gray2, weight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  _guaranteeContainer(BuildContext context) {
    String guaranteeTitle = '';

    if (issueItem.guarantee == 1) {
      guaranteeTitle = '${issueItem.guarantee} ${S.of(context).general_month}';
    } else if (issueItem.guarantee > 1) {
      guaranteeTitle = '${issueItem.guarantee} ${S.of(context).general_months}';
    }

    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${S.of(context).general_guarantee}:',
            style: TextHelper.customTextStyle(color: black_text),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              guaranteeTitle,
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  _quantityContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${S.of(context).car_details_quantity}:',
            style: TextHelper.customTextStyle(color: black_text),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              issueItem.quantity.toString(),
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  _priceContainer(BuildContext context) {
    double price = issueItem.getPrice() + issueItem.priceVAT;

    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${S.of(context).general_price}:',
            style: TextHelper.customTextStyle(color: black_text),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              issueItem.price.toStringAsFixed(2),
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              '(${price.toStringAsFixed(2)}',
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              '${S.of(context).estimator_priceVAT})',
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  _additionContainer(BuildContext context) {
    if (issueItem.addition != null && issueItem.addition != 0) {
      return Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '${S.of(context).general_addition}:',
              style: TextHelper.customTextStyle(color: black_text),
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                '${issueItem.addition.toString()}%',
                style: TextHelper.customTextStyle(
                    color: red, weight: FontWeight.bold, size: 14),
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  _totalContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${S.of(context).estimator_total}:',
            style: TextHelper.customTextStyle(color: black_text),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              issueItem.total.toStringAsFixed(1),
              style: TextHelper.customTextStyle(
                  color: red, weight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _translateType(BuildContext context, String type) {
    switch (type) {
      case 'SERVICE':
        return S.of(context).estimator_service;
      case 'PRODUCT':
        return S.of(context).estimator_product;
      default:
        return '';
    }
  }
}
