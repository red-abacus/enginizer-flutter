import 'package:app/generated/l10n.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/auctions/widgets/details-consultant/car-details-parts.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionConsultantPartsWidget extends StatelessWidget {
  final AuctionDetail auctionDetails;
  final Function createEstimate;
  final Function seeEstimate;
  final Function showProviderDetails;

  AuctionConsultantPartsWidget(
      {this.auctionDetails,
      this.createEstimate,
      this.seeEstimate,
      this.showProviderDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarDetailsPartsWidget(car: auctionDetails.car),
      floatingActionButton: _floatingButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _floatingButtons(BuildContext context) {
    List<Widget> buttons = [];

    buttons.add(FloatingActionButton.extended(
      heroTag: null,
      onPressed: () {
        showProviderDetails();
      },
      label: Text(
        S.of(context).online_shop_appointment_provider_details.toUpperCase(),
        style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 12),
      ),
      backgroundColor: Colors.white,
    ));

    buttons.add(FloatingActionButton.extended(
      heroTag: null,
      onPressed: () {
        if (createEstimate != null) {
          createEstimate();
        } else if (seeEstimate != null) {
          seeEstimate();
        }
      },
      label: Text(
        createEstimate != null
            ? S.of(context).auction_create_estimate.toUpperCase()
            : S.of(context).appointment_details_estimator.toUpperCase(),
        style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold, size: 12),
      ),
      backgroundColor: Colors.white,
    ));

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons,
      ),
    );
  }
}
