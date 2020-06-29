import 'package:app/generated/l10n.dart';
import 'package:app/modules/invoices/enums/invoice-sort.enum.dart';
import 'package:app/modules/invoices/enums/invoice-type.enum.dart';
import 'package:app/modules/invoices/models/invoice.model.dart';
import 'package:app/modules/invoices/widgets/cards/invoice.card.dart';
import 'package:app/modules/shared/widgets/custom-text-field-duration.dart';
import 'package:app/modules/shared/widgets/single-select-dialog.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InvoicesList extends StatelessWidget {
  List<Invoice> invoices = [];

  String searchString;

  final Function filterInvoices;
  final Function selectInvoice;
  final Function downloadNextPage;
  final InvoiceSort invoiceSort;
  final InvoiceType invoiceType;
  bool shouldDownload = true;

  InvoicesList(
      {this.invoices,
      this.filterInvoices,
      this.selectInvoice,
      this.searchString,
      this.downloadNextPage,
      this.shouldDownload,
      this.invoiceSort,
      this.invoiceType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildSearchBar(context),
          _buildFilterWidget(context),
          _buildListView(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      child: CustomDebouncerTextField(
        labelText: S.of(context).invoice_search_title,
        currentValue: searchString != null ? searchString : '',
        listener: (val) {
          this.filterInvoices(val, this.invoiceSort, this.invoiceType);
        },
      ),
    );
  }

  Widget _buildFilterWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 0.5, color: gray),
                ),
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_sortText(context)],
                ),
              ),
              onTap: () => _showSortPicker(
                (context),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 0.5, color: gray),
                ),
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_typeText(context)],
                ),
              ),
              onTap: () => _showTypePicker(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return new Expanded(
      child: Container(
          padding: EdgeInsets.only(top: 10),
          child: this.invoices.length == 0
              ? Center(
                  child: Text(S.of(context).invoice_empty_list_title, style: TextHelper.customTextStyle(size: 16, color: gray3),),
                )
              : ListView.builder(
                  itemBuilder: (ctx, index) {
                    if (shouldDownload) {
                      if (index == this.invoices.length - 1) {
                        downloadNextPage();
                      }
                    }
                    return InvoiceCard(
                        invoice: this.invoices[index],
                        selectInvoice: this.selectInvoice);
                  },
                  itemCount: this.invoices.length,
                )),
    );
  }

  _sortText(BuildContext context) {
    String title = (this.invoiceSort == null)
        ? S.of(context).invoice_sort_title
        : InvoiceSortUtils.title(context, invoiceSort);

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            'assets/images/icons/filter.svg'.toLowerCase(),
            color: red,
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 2),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextHelper.customTextStyle(color: gray3, size: 16),
            ),
          ),
        )
      ],
    );
  }

  _typeText(BuildContext context) {
    String title = (this.invoiceType == null)
        ? S.of(context).invoice_type_title
        : InvoiceTypeUtils.title(context, this.invoiceType);

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            'assets/images/icons/filter.svg'.toLowerCase(),
            color: red,
          ),
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(right: 2),
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextHelper.customTextStyle(color: gray3, size: 16),
            ),
          ),
        )
      ],
    );
  }

  _showSortPicker(BuildContext context) async {
    List<SingleSelectDialogItem<InvoiceSort>> items = [];

    InvoiceSortUtils.list().forEach((sort) {
      items.add(
          SingleSelectDialogItem(sort, InvoiceSortUtils.title(context, sort)));
    });

    InvoiceSort sort = await showDialog<InvoiceSort>(
      context: context,
      builder: (BuildContext context) {
        return SingleSelectDialog(
          items: items,
          initialSelectedValue: this.invoiceSort,
          title: S.of(context).invoice_sort_title,
        );
      },
    );

    this.filterInvoices(this.searchString, sort, this.invoiceType);
  }

  _showTypePicker(BuildContext context) async {
    List<SingleSelectDialogItem<InvoiceType>> items = [];

    InvoiceTypeUtils.list().forEach((type) {
      items.add(
          SingleSelectDialogItem(type, InvoiceTypeUtils.title(context, type)));
    });

    InvoiceType type = await showDialog<InvoiceType>(
      context: context,
      builder: (BuildContext context) {
        return SingleSelectDialog(
          items: items,
          initialSelectedValue: this.invoiceType,
          title: S.of(context).invoice_type_title,
        );
      },
    );

    this.filterInvoices(this.searchString, this.invoiceSort, type);
  }
}
