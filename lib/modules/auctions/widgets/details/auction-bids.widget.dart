import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid.model.dart';
import 'package:enginizer_flutter/modules/auctions/widgets/cards/bid.card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionBidsWidget extends StatefulWidget {
  Auction auction;

  Function selectBid;

  AuctionBidsWidget({this.auction, this.selectBid});

  @override
  AuctionBidsWidgetState createState() {
    return AuctionBidsWidgetState();
  }
}

class AuctionBidsWidgetState extends State<AuctionBidsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildSearchWidget(context),
            _buildList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchWidget(BuildContext context) {
    String value = "Cauta";

    return Container(
      child: TextField(
        key: Key('searchBar'),
        autofocus: false,
        decoration: InputDecoration(labelText: value),
        onChanged: (val) {},
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return BidCard(bid: new Bid(id: 23), selectBid: widget.selectBid);
          },
          itemCount: 20,
        ),
      ),
    );
  }
}
