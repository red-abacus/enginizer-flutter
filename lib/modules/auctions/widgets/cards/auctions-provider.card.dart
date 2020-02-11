import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuctionProviderCard extends StatelessWidget {
  ServiceProvider serviceProvider;

  AuctionProviderCard({this.serviceProvider});

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
          onTap: () => {},
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _imageContainer(),
                _textContainer(),
                FlatButton(
                    color: Colors.blue,
                    child: Text(
                      S.of(context).general_details,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: red,
                          fontFamily: "Lato"),
                    ),
                    onPressed: () {
//                      Provider.of<ProviderServiceProvider>(context)
//                          .loadProviderServices(currentService);
//                      showModalBottomSheet(
//                          isScrollControlled: true,
//                          context: context,
//                          builder: (_) {
//                            return StatefulBuilder(builder:
//                                (BuildContext context, StateSetter state) {
//                              return ServiceDetailsModal(currentService);
//                            });
//                          });
//                    }),
                    }),
//                Container(
//                  width: LIST_ITEM_SELECTION_WIDTH,
//                  child: Column(
//                    children: [
//                      if (providerServiceProvider.selectedProvider ==
//                          currentService)
//                        Container(
//                          height: 100,
//                          color: Theme.of(context).accentColor,
//                        )
//                    ],
//                  ),
//                ),
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
      height: 100,
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
        color: red,
        margin: EdgeInsets.only(left: 10),
        height: 100,
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
                Text(
                  'test',
//                    '${auction.car?.brand?.name} ${auction.car?.model?.name} ${auction.car?.year?.name}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.8,
                        height: 1.5)),
                Text('test 2',
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
                    child: Text("Ora programare: 11.02.2020 la 11:00",
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
}
