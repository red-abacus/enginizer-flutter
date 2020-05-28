import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceProviderCard extends StatelessWidget {
  final ServiceProvider serviceProvider;
  final bool selected;

  final Function selectServiceProvider;
  final Function showServiceProviderDetails;

  ServiceProviderCard(
      {this.serviceProvider,
      this.selectServiceProvider,
      this.selected,
      this.showServiceProviderDetails});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const double LIST_ITEM_SELECTION_WIDTH = 7;
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: new BorderRadius.circular(5.0),
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            onTap: () => {selectServiceProvider(serviceProvider)},
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    width: 100,
                    height: 100,
                    image: serviceProvider.image,
                    placeholder: ServiceProvider.defaultImage(),
                    fit: BoxFit.contain,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text("${serviceProvider.name}",
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        height: 1.5)),
                              ),
                            ],
                          ),
                          Text("@${serviceProvider.address}",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                      color: Colors.transparent,
                      child: Text(
                        S.of(context).general_details,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: red,
                            fontFamily: "Lato"),
                      ),
                      onPressed: () {
                        showServiceProviderDetails(serviceProvider);
                      }),
                  Container(
                    width: LIST_ITEM_SELECTION_WIDTH,
                    child: Column(
                      children: [
                        if (selected)
                          Container(
                            height: 100,
                            color: Theme.of(context).accentColor,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
