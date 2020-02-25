import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:enginizer_flutter/generated/l10n.dart';

class AuctionConsultantCard extends StatelessWidget {
  final Auction auction;
  final Function selectAuction;

  AuctionConsultantCard({this.auction, this.selectAuction});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            onTap: () => this.selectAuction(this.auction),
            child: ClipRRect(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _imageContainer(),
                    _textContainer(),
                    _statusContainer(context),
                  ]),
            ),
          ),
        ),
      );
    });
  }

  _imageContainer() {
    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.all(10),
      color: red,
      child: SvgPicture.asset(
        'assets/images/statuses/in_bid.svg',
        semanticsLabel: 'Appointment Status Image',
      ),
    );
  }

  _textContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        height: 100,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text('${auction.car?.registrationNumber}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.5)),
                Text(
                    '${auction.car?.brand?.name} ${auction.car?.model?.name} ${auction.car?.year?.name}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.8,
                        height: 1.5)),
                Text('${auction.createdDate}',
                    style: TextStyle(
                        color: gray,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        height: 1.5)),
                SizedBox(height: 10),
              ],
            ),
            Positioned(
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text("${auction.appointment?.name}",
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            fontSize: 11.2,
                            height: 1.5)),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _statusContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Text(
        S.of(context).general_auction.toUpperCase(),
        textAlign: TextAlign.right,
        style: TextHelper.customTextStyle(null, red, FontWeight.bold, 12),
      ),
    );
  }
}
