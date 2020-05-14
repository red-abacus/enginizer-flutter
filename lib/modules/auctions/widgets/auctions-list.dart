import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/widgets/cards/auction.card.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionsList extends StatelessWidget {
  final List<Auction> auctions;

  Function filterAuctions;
  Function selectAuction;
  Function downloadNextPage;

  String searchString;
  AuctionStatus auctionStatus;

  AuctionsList(
      {this.auctions,
      this.filterAuctions,
      this.selectAuction,
      this.searchString,
      this.auctionStatus,
      this.downloadNextPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildSearchWidget(context),
            _buildFilterWidget(context),
            _buildList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchWidget(BuildContext context) {
    print('auction status ${this.auctionStatus}');
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10),
      child: TextField(
        key: Key('searchBar'),
        autofocus: false,
        decoration:
            InputDecoration(labelText: S.of(context).auctions_search_hint),
        onChanged: (val) {
          this.filterAuctions(val, this.auctionStatus);
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
            height: 40,
            child: DropdownButtonFormField(
              isDense: true,
              hint: _statusText(context),
              items: _statusDropdownItems(context),
              onChanged: (newValue) {
                this.filterAuctions(this.searchString, newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusText(BuildContext context) {
    String title = (this.auctionStatus == null)
        ? S.of(context).general_status
        : AuctionStatusUtils.titleFromStatus(this.auctionStatus, context);

    return Text(
      title,
      style: TextHelper.customTextStyle(null, Colors.grey, null, 12),
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            if (index == auctions.length - 1) {
              downloadNextPage();
            }
            return AuctionCard(
                auction: auctions[index], selectAuction: _selectAuction);
          },
          itemCount: auctions.length,
        ),
      ),
    );
  }

  _statusDropdownItems(BuildContext context) {
    List<DropdownMenuItem<AuctionStatus>> brandDropdownList = [];
    AuctionStatusUtils.statuses().forEach((status) {
      brandDropdownList.add(DropdownMenuItem(
          value: status, child: Text(AuctionStatusUtils.titleFromStatus(status, context))));
    });
    return brandDropdownList;
  }

  _selectAuction(Auction auction) {
    this.selectAuction(auction);
  }
}
