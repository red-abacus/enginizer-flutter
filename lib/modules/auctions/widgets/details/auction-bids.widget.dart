import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/models/bid.model.dart';
import 'package:app/modules/auctions/widgets/cards/bid.card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionBidsWidget extends StatefulWidget {
  List<Bid> bids;

  Function selectBid;
  Function filterBids;

  String filterSearchString;

  AuctionBidsWidget({this.bids, this.filterSearchString, this.selectBid, this.filterBids});

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
    String value = S.of(context).general_find;

    if (widget.filterSearchString.isNotEmpty) {
      value = widget.filterSearchString;
    }

    return Container(
      child: TextField(
        key: Key('searchBar'),
        autofocus: false,
        decoration: InputDecoration(labelText: value),
        onChanged: (val) {
          widget.filterBids(val);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return BidCard(
                bid: widget.bids[index], selectBid: widget.selectBid);
          },
          itemCount: widget.bids.length,
        ),
      ),
    );
  }
}
