import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PartCard extends StatelessWidget {
  final ProviderItem providerItem;
  final Function selectPart;

  PartCard({this.providerItem, this.selectPart});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: gray_80,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            onTap: () => {selectPart(providerItem)},
            child: ClipRRect(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _imageContainer(),
                    _textContainer(context),
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
      child: Image.network(
        'https://previews.123rf.com/images/eldoctore/eldoctore1209/eldoctore120900008/15251596-brake-disc-and-red-calliper-from-a-racing-car-isolated-on-white-background.jpg',
        fit: BoxFit.fitWidth,
      ),
    );
  }

  _textContainer(BuildContext context) {
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
                Text(providerItem.name,
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.5)),
                Text(
                    '${S.of(context).general_price}: ${providerItem.price} RON',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.8,
                        height: 1.5)),
                Text(
                    '${S.of(context).general_tva}: ${providerItem.priceVAT} RON',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.8,
                        height: 1.5)),
                SizedBox(height: 10),
              ],
            ),
            Positioned(
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(providerItem.code,
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
        '${providerItem.price + providerItem.priceVAT} RON',
        textAlign: TextAlign.right,
        style: TextHelper.customTextStyle(
            color: red, weight: FontWeight.bold, size: 12),
      ),
    );
  }
}
