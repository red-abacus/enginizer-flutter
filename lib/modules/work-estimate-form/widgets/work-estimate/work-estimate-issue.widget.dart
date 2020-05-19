import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkEstimateIssueWidget extends StatelessWidget {
  final IssueItem issueItem;
  final Function removeIssueItem;

  final EstimatorMode estimatorMode;

  WorkEstimateIssueWidget(
      {this.issueItem, this.removeIssueItem, this.estimatorMode});

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${issueItem.name} (${issueItem.code})',
                                style: TextHelper.customTextStyle(
                                    null, black_text, FontWeight.bold, 16),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '${S.of(context).estimator_type}: ${_translateType(context, issueItem.type.name)}',
                                  style: TextHelper.customTextStyle(
                                      null, gray2, FontWeight.bold, 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${S.of(context).car_details_quantity}:',
                                style: TextHelper.customTextStyle(
                                    null, black_text, null, 14),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  issueItem.quantity.toString(),
                                  style: TextHelper.customTextStyle(
                                      null, red, FontWeight.bold, 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${S.of(context).general_price}:',
                                style: TextHelper.customTextStyle(
                                    null, black_text, null, 14),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  issueItem.price.toString(),
                                  style: TextHelper.customTextStyle(
                                      null, red, FontWeight.bold, 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  '(${(issueItem.price + issueItem.priceVAT).toString()}',
                                  style: TextHelper.customTextStyle(
                                      null, red, FontWeight.bold, 14),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  '${S.of(context).estimator_priceVAT})',
                                  style: TextHelper.customTextStyle(
                                      null, red, FontWeight.bold, 14),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _getRemoveButton(context, issueItem),
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

  _getRemoveButton(BuildContext context, IssueItem issueItem) {
    switch (estimatorMode) {
      case EstimatorMode.ReadOnly:
      case EstimatorMode.Client:
      case EstimatorMode.ClientAccept:
      case EstimatorMode.Edit:
        return Container();
      case EstimatorMode.Edit:
        return Container();
      default:
        return Container(
          alignment: Alignment.center,
          width: 54.0,
          height: 54.0,
          child: GestureDetector(
              onTap: () => removeIssueItem(issueItem),
              child: Icon(Icons.close,
                  color: Theme.of(context).accentColor, size: 32)),
        );
    }
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
