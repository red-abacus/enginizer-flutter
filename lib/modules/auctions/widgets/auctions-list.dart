import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/cards/auction-card.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionsList extends StatelessWidget {
  final List<CarBrand> carBrands;
  final List<Auction> auctions;

  Function filterAuctions;

  AuctionsList({this.carBrands, this.auctions, this.filterAuctions});

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
        decoration: InputDecoration(labelText: S.of(context).auctions_search_hint),
        onChanged: (val) {
          this.filterAuctions(val);
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
              hint: Text(
                S.of(context).general_status,
                style: TextHelper.customTextStyle(null, Colors.grey, null, 12),
              ),
              items: _statusDropdownItems(context),
              onChanged: (newValue) {
              print("status value ${newValue}");
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
              hint: Text(
                S.of(context).general_car,
                style: TextHelper.customTextStyle(null, Colors.grey, null, 12),
              ),
              items: _brandDropdownItems(carBrands),
              onChanged: (newValue) {
                print("new value ${newValue}");
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return AuctionCard(auction: auctions[index], selectAuction: _selectAuction);
          },
          itemCount: auctions.length,
        ),
      ),
    );
  }

  _statusDropdownItems(BuildContext context) {
    List<DropdownMenuItem<String>> brandDropdownList = [];
    brandDropdownList
        .add(DropdownMenuItem(value: S.of(context).general_auction, child: Text(S.of(context).general_auction)));
    brandDropdownList
        .add(DropdownMenuItem(value: S.of(context).auctions_finished, child: Text(S.of(context).auctions_finished)));
    brandDropdownList
        .add(DropdownMenuItem(value: S.of(context).general_all.toUpperCase(), child: Text(S.of(context).general_all.toUpperCase())));
    return brandDropdownList;
  }

  _brandDropdownItems(List<CarBrand> brands) {
    List<DropdownMenuItem<CarBrand>> brandDropdownList = [];
    brands.forEach((brand) => brandDropdownList
        .add(DropdownMenuItem(value: brand, child: Text(brand.name))));
    return brandDropdownList;
  }

  _selectAuction(Auction auction) {

  }
}
