import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/estimator/estimator-form.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final estimatorStateKey = new GlobalKey<EstimatorFormState>();

class EstimatorIssueDetails extends StatefulWidget {
  final Issue issue;

  final Function addIssueItem;
  final Function removeIssueItem;

  EstimatorIssueDetails({this.issue, this.addIssueItem, this.removeIssueItem});

  @override
  _EstimatorIssueDetailsState createState() => _EstimatorIssueDetailsState();
}

class _EstimatorIssueDetailsState extends State<EstimatorIssueDetails> {
  @override
  Widget build(BuildContext context) {
    Widget issueItemsTable = _buildTable(context, widget.issue.items);
    Widget issueItemForm = _buildForm(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        (widget.issue.items.isNotEmpty)
            ? issueItemsTable
            : Text(S.of(context).general_no_entries),
        issueItemForm,
      ],
    );
  }

  Widget _buildTable(BuildContext context, List<IssueItem> issueItems) =>
      SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // First column is fixed (IssueItem Name)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First column's header
                _buildCell(
                  S.of(context).estimator_name.toUpperCase(),
                  firstColumn: true,
                  headerCell: true,
                ),
                // Values of the first column
                Column(
                  children: _buildCells(issueItems, 'name'),
                ),
              ],
            ),
            Flexible(
              // The rest of the columns are scrollable horizontally
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: <Widget>[
                          _buildCell(
                            S.of(context).estimator_type.toUpperCase(),
                            headerCell: true,
                          ),
                          Column(
                            children: _buildCells(issueItems, 'type'),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          _buildCell(
                            S.of(context).estimator_code.toUpperCase(),
                            headerCell: true,
                          ),
                          Column(
                            children: _buildCells(issueItems, 'code'),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          _buildCell(
                            S.of(context).estimator_quantity.toUpperCase(),
                            headerCell: true,
                          ),
                          Column(
                            children: _buildCells(issueItems, 'quantity'),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          _buildCell(
                            S.of(context).estimator_priceNoVAT.toUpperCase(),
                            headerCell: true,
                          ),
                          Column(
                            children: _buildCells(issueItems, 'priceNoVAT'),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          _buildCell(
                            S.of(context).estimator_priceVAT.toUpperCase(),
                            headerCell: true,
                          ),
                          Column(
                            children: _buildCells(issueItems, 'priceVAT'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  List<Widget> _buildCells(List<IssueItem> issueItems, String fieldName) {
    List<Widget> cells = [];
    issueItems.forEach((issueItem) {
      String fieldValue = issueItem.toMap()[fieldName];
      if (fieldName == 'type') {
        fieldValue = _translateType(fieldValue);
      }
      cells.add(_buildCell(fieldValue, firstColumn: fieldName == 'name'));
    });
    return cells;
  }

  Widget _buildCell(String fieldValue,
          {bool firstColumn = false, bool headerCell = false}) =>
      Container(
        alignment: Alignment.centerLeft,
        width: firstColumn ? MediaQuery.of(context).size.width * 0.4 : 120,
        height: 54.0,
        padding: EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
          color: headerCell ? Theme.of(context).primaryColor : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.black12),
          ),
        ),
        child: Text(
          fieldValue.toString(),
          style: TextStyle(
            color: headerCell ? Colors.white : Colors.black87,
            fontWeight: headerCell ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      );

  Widget _buildForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          EstimatorForm(key: estimatorStateKey),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: FloatingActionButton(
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
