
import 'package:app/generated/l10n.dart';
import 'package:app/modules/promotions/enum/promotion-status.enum.dart';
import 'package:app/modules/promotions/models/promotion.model.dart';
import 'package:app/modules/promotions/widgets/cards/promotion.card.dart';
import 'package:app/modules/shared/widgets/custom-text-field-duration.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PromotionsList extends StatelessWidget {
  List<Promotion> promotions = [];

  String searchString;
  PromotionStatus promotionStatus;

  final Function selectPromotion;
  final Function filterPromotions;
  final Function downloadNextPage;
  bool shouldDownload = true;

  PromotionsList(
      {this.promotions,
        this.selectPromotion,
        this.filterPromotions,
        this.searchString,
        this.promotionStatus,
        this.downloadNextPage,
        this.shouldDownload});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildSearchBar(context),
              _buildFilterWidget(context),
              _buildListView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      child: CustomDebouncerTextField(
        labelText: S.of(context).promotions_list_search_hint,
        currentValue: searchString != null ? searchString : '',
        listener: (val) {
          filterPromotions(val, this.promotionStatus);
        },
      ),
    );
  }

  Widget _buildFilterWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(right: 10),
            child: DropdownButtonFormField(
              isDense: true,
              hint: _statusText(context),
              items: _statusDropdownItems(context),
              onChanged: (newValue) {
                filterPromotions(this.searchString, newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context) {
    return new Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            if (shouldDownload) {
              if (index == this.promotions.length - 1) {
                downloadNextPage();
              }
            }
            return PromotionCard(
                promotion: this.promotions[index],
                selectPromotion: selectPromotion);
          },
          itemCount: this.promotions.length,
        ),
      ),
    );
  }

  Widget _statusText(BuildContext context) {
    String title = (this.promotionStatus == null)
        ? S.of(context).general_status
        : PromotionStatusUtils.title(context, this.promotionStatus);

    return Text(
      title,
      style: TextHelper.customTextStyle(color: Colors.grey, size: 15),
    );
  }

  _statusDropdownItems(BuildContext context) {
    List<DropdownMenuItem<PromotionStatus>> list = [];

    var statuses = [
      PromotionStatus.Pending,
      PromotionStatus.Finished,
      PromotionStatus.Paused,
      PromotionStatus.Active
    ];

    statuses.forEach((status) {
      list.add(DropdownMenuItem(
          value: status,
          child: Text(PromotionStatusUtils.title(context, status))));
    });

    return list;
  }
}
