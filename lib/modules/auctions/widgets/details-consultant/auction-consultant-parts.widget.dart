import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/auctions/models/auction-details.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/widgets/text_widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuctionConsultantPartsWidget extends StatelessWidget {
  final AuctionDetail auctionDetails;
  final AppointmentDetail appointmentDetail;
  final Function createEstimate;
  final Function seeEstimate;
  final Function showProviderDetails;

  AuctionConsultantPartsWidget(
      {this.auctionDetails,
      this.appointmentDetail,
      this.createEstimate,
      this.seeEstimate,
      this.showProviderDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCarDetails(context, auctionDetails.car),
      floatingActionButton: _floatingButtons(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCarDetails(BuildContext context, Car car) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.network(
                    '${car.image}',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (car.brand?.name != null)
                      ? Padding(
                          padding:
                              EdgeInsets.only(left: 20, top: 20, right: 20),
                          child: TextWidget(
                            "${car.brand?.name}",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
                  (car.year?.name != null && car.color?.name != null)
                      ? Padding(
                          padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                          child: TextWidget(
                            "${car.year?.name}, ${car.color?.translateColorName(context)}",
                            fontSize: 14,
                          ),
                        )
                      : Container(),
                  (car.power?.name != null && car.motor?.name != null)
                      ? Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 25),
                          child: TextWidget(
                              "${car.power?.name}, ${car.motor?.name}"))
                      : Container(),
                  (car.mileage != null)
                      ? Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: TextWidget(
                              "${NumberFormat.decimalPattern().format(car.mileage)} KM"),
                        )
                      : Container()
                ],
              ),
            ],
          ),
        ),
      ),
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
        style: TextHelper.customTextStyle(null, red, FontWeight.bold, 12),
      ),
      backgroundColor: Colors.white,
    ));

    buttons.add(FloatingActionButton.extended(
      heroTag: null,
      onPressed: () {
        if (createEstimate != null) {
          createEstimate();
        }
        else if (seeEstimate != null) {
          seeEstimate();
        }
      },
      label: Text(
        createEstimate != null ? S.of(context).auction_create_estimate.toUpperCase() : S.of(context).appointment_details_estimator.toUpperCase(),
        style: TextHelper.customTextStyle(null, red, FontWeight.bold, 12),
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
