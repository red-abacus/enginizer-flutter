import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/auctions/models/bid.model.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BidCard extends StatelessWidget {
  final Bid bid;
  final Function selectBid;

  BidCard({this.bid, this.selectBid});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 1,
        color: Colors.white,
        borderRadius: new BorderRadius.circular(5.0),
        child: InkWell(
          splashColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          onTap: () => {
            selectBid(bid)
          },
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _imageContainer(),
                _textContainer(),
                _detailsContainer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _imageContainer() {
    return Container(
      color: red,
      width: 100,
      height: 120,
      child: SvgPicture.asset(
        'assets/images/statuses/in_bid.svg'.toLowerCase(),
        semanticsLabel: 'Appointment Status Image',
        height: 60,
        width: 60,
      ),
    );

    //                Image.network(
//                  '${currentService.image}',
//                  fit: BoxFit.fitHeight,
//                  height: 100,
//                  width: 100,
//                ),
  }

  _textContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        height: 120,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text("Service Center",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.5)),
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/images/icons/star_icon.svg',
                      semanticsLabel: 'Review Image',
                      height: 14,
                      width: 14,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "4.6 (1766)",
                        style: TextHelper.customTextStyle(null, gray, null, 11),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Servicii: Doar 1 serviciu",
                    style: TextStyle(
                        color: yellow,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.8,
                        height: 1.5)),
                Text('Cost: 700 ron',
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
                    child: Text("Ora programare:\n11.02.2020 la 11:00",
                        style: TextStyle(
                            color: gray,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.normal,
                            fontSize: 10,
                            height: 1.5)),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _detailsContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Text(
        S.of(context).general_details,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: red,
            fontFamily: "Lato"),
      ),
    );
  }
}
