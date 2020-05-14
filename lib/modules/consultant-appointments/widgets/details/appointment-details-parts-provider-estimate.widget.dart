import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment-provider-type.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/consultant-appointments/widgets/cards/service-provider.card.dart';
import 'package:app/modules/shared/widgets/alert-info.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsPartsProviderEstimateWidget extends StatelessWidget {
  final AppointmentProviderType providerType;
  final List<ServiceProvider> serviceProviders;
  final ServiceProvider selectedServiceProvider;

  final Function selectProviderType;
  final Function downloadNextServiceProviders;
  final Function selectServiceProvider;
  final Function showServiceProviderDetails;
  final Function requestItems;

  AppointmentDetailsPartsProviderEstimateWidget(
      {this.providerType,
      this.serviceProviders,
      this.selectedServiceProvider,
      this.selectProviderType,
      this.downloadNextServiceProviders,
      this.selectServiceProvider,
      this.showServiceProviderDetails,
      this.requestItems});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    S.of(context).appointment_create_step3_specific,
                    style: new TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                      color: gray,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  new Switch(
                    value: providerType == AppointmentProviderType.Auction,
                    onChanged: (bool isOn) {
                      if (isOn) {
                        selectProviderType(AppointmentProviderType.Auction);
                      } else {
                        selectProviderType(AppointmentProviderType.Specific);
                      }
                    },
                    activeTrackColor: switch_dark_gray,
                    inactiveThumbColor: red,
                    inactiveTrackColor: switch_dark_gray,
                    activeColor: red,
                    hoverColor: Colors.blue,
                  ),
                  new Text(
                    S.of(context).appointment_create_step3_bid,
                    style: new TextStyle(
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              _contentWidget(context),
            ],
          ),
        ),
        _bottomContainer(context),
      ],
    );
  }

  _contentWidget(BuildContext context) {
    if (providerType == AppointmentProviderType.Specific) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(bottom: 60),
          margin: EdgeInsets.only(top: 10, right: 20, left: 20),
          child: ListView.builder(
            itemCount: this.serviceProviders.length,
            itemBuilder: (context, index) {
              if (index == this.serviceProviders.length - 1) {
                this.downloadNextServiceProviders();
              }
              return ServiceProviderCard(
                serviceProvider: serviceProviders[index],
                selectServiceProvider: selectServiceProvider,
                selected: selectedServiceProvider == serviceProviders[index],
                showServiceProviderDetails: showServiceProviderDetails,
              );
            },
          ),
        ),
      );
    }
    return new Container(
      margin: EdgeInsets.only(top: 10),
      child: new SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: new Container(
            margin: EdgeInsets.only(top: 20),
            child: new AlertInfoWidget(
                S.of(context).appointment_consultant_provider_auction_alert),
          )),
    );
  }

  _bottomContainer(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Spacer(),
            FlatButton(
              color: gray2,
              child: Text(
                S.of(context).general_send,
                style: TextHelper.customTextStyle(null, Colors.white, null, 14),
              ),
              onPressed: () {
                requestItems();
              },
            )
          ],
        ),
      ),
    );
  }
}
