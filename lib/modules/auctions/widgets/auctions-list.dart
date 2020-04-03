import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/consultant-auctions/cards/auction-consultant.card.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionsList extends StatelessWidget {
  final List<CarBrand> carBrands;
  final List<Auction> auctions;

  Function filterAuctions;
  Function selectAuction;

  String searchString;
  AuctionStatus auctionStatus;
  CarBrand carBrand;

  AuctionsList(
      {this.carBrands,
      this.auctions,
      this.filterAuctions,
      this.selectAuction,
      this.searchString,
      this.auctionStatus,
      this.carBrand});

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
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10),
      child: TextField(
        key: Key('searchBar'),
        autofocus: false,
        decoration:
            InputDecoration(labelText: S.of(context).auctions_search_hint),
        onChanged: (val) {
          this.filterAuctions(val, this.auctionStatus, this.carBrand);
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
                this.filterAuctions(this.searchString, newValue, this.carBrand);
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            child: DropdownButtonFormField(
              isDense: true,
              hint: _brandText(context),
              items: _brandDropdownItems(carBrands),
              onChanged: (newValue) {
                this.filterAuctions(
                    this.searchString, this.auctionStatus, newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _brandText(BuildContext context) {
    String title =
        (this.carBrand == null) ? S.of(context).general_car : carBrand.name;

    return Text(
      title,
      style: TextHelper.customTextStyle(null, Colors.grey, null, 12),
    );
  }

  Widget _statusText(BuildContext context) {
    String title = (this.auctionStatus == null)
        ? S.of(context).general_status
        : _titleFromState(this.auctionStatus, context);

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
            return AuctionConsultantCard(
                auction: auctions[index], selectAuction: _selectAuction);
          },
          itemCount: auctions.length,
        ),
      ),
    );
  }

  _statusDropdownItems(BuildContext context) {
    List<DropdownMenuItem<AuctionStatus>> brandDropdownList = [];
    brandDropdownList.add(DropdownMenuItem(
        value: AuctionStatus.IN_BID,
        child: Text(S.of(context).general_auction)));
    brandDropdownList.add(DropdownMenuItem(
        value: AuctionStatus.FINISHED,
        child: Text(S.of(context).auctions_finished)));
    brandDropdownList.add(DropdownMenuItem(
        value: AuctionStatus.ALL,
        child: Text(S.of(context).general_all.toUpperCase())));
    return brandDropdownList;
  }

  _brandDropdownItems(List<CarBrand> brands) {
    List<DropdownMenuItem<CarBrand>> brandDropdownList = [];
    brands.forEach((brand) => brandDropdownList
        .add(DropdownMenuItem(value: brand, child: Text(brand.name))));
    return brandDropdownList;
  }

  _selectAuction(Auction auction) {
    this.selectAuction(auction);
  }

  _titleFromState(AuctionStatus status, BuildContext context) {
    switch (status) {
      case AuctionStatus.IN_BID:
        return S.of(context).general_auction;
      case AuctionStatus.FINISHED:
        return S.of(context).auctions_finished;
      case AuctionStatus.ALL:
        return S.of(context).general_all;
    }
  }
}
