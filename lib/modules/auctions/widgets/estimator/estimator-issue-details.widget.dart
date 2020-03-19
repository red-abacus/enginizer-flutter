import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/enums/estimator-mode.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/estimator/estimator-form.widget.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final estimatorStateKey = new GlobalKey<EstimatorFormState>();

class EstimatorIssueDetails extends StatefulWidget {
  final EstimatorMode mode;
  final Issue issue;

  final Function addIssueItem;
  final Function removeIssueItem;

  EstimatorIssueDetails(
      {this.mode, this.issue, this.addIssueItem, this.removeIssueItem});

  @override
  _EstimatorIssueDetailsState createState() => _EstimatorIssueDetailsState();
}

class _EstimatorIssueDetailsState extends State<EstimatorIssueDetails> {
  @override
  Widget build(BuildContext context) {
    Widget issueItemsTable = _buildTable(context, widget.issue.items);
    Widget issueItemForm = _buildForm(context);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          (widget.issue.items.isNotEmpty)
              ? issueItemsTable
              : Text(S.of(context).general_no_entries),
          if (widget.mode == EstimatorMode.Edit)
            issueItemForm,
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<IssueItem> issueItems) =>
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (IssueItem item in issueItems) _buildItemRow(item)
          ],
        ),
      );

  _buildItemRow(IssueItem issueItem) {
    return Container(
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
                              '${S.of(context).estimator_type}: ${_translateType(issueItem.type.name)}',
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
                            '${S.of(context).general_price}:',
                            style: TextHelper.customTextStyle(null, black_text, null, 14),
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
              _getRemoveButton(issueItem),
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
      )
    );
  }

  _getRemoveButton(IssueItem issueItem) {
    if (widget.mode == EstimatorMode.Edit) {
      return Container(
        alignment: Alignment.center,
        width: 54.0,
        height: 54.0,
        child: GestureDetector(
            onTap: () =>
                widget.removeIssueItem(widget.issue, issueItem),
            child: Icon(Icons.close,
                color: Theme.of(context).accentColor, size: 32)),
      );
    }
    else {
      return Container();
    }
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          EstimatorForm(key: estimatorStateKey),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: FloatingActionButton(
                heroTag: null,
                onPressed: () => widget.addIssueItem(widget.issue),
                child: Icon(Icons.add)),
          ),
        ],
      ),
    );
  }

  String _translateType(String type) {
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
