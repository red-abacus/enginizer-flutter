import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/appointments/widgets/cards/service-provider-review.card.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ServiceProviderReviewsWidget extends StatefulWidget {
  @override
  ServiceProviderReviewsWidgetState createState() {
    return ServiceProviderReviewsWidgetState();
  }
}

class ServiceProviderReviewsWidgetState
    extends State<ServiceProviderReviewsWidget> {
  ServiceProviderDetailsProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ServiceProviderDetailsProvider>(context);
    int count = 1 + provider.serviceProviderReview.clientReviews.length;

    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildRow(index);
      },
      scrollDirection: Axis.vertical,
      itemCount: count,
    );
  }

  Widget _buildRow(int index) {
    if (index == 0) {
      return _buildReviewRow();
    } else {
      return ServiceProviderReviewCard(
          review: provider.serviceProviderReview.clientReviews[index - 1]);
    }
  }

  _buildReviewRow() {
    String contactResponseHour = provider.serviceProviderReview
                .serviceProviderReviewDetails.averageContactResponseTime >
            1.0
        ? S.of(context).general_hours
        : S.of(context).general_hour;
    String offerResponseHour = provider.serviceProviderReview
                .serviceProviderReviewDetails.averageOfferResponseTime >
            1.0
        ? S.of(context).general_hours
        : S.of(context).general_hour;

    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          _buildReviewText(
              S.of(context).appointment_reviews_executed_appointments,
              provider.serviceProviderReview.serviceProviderReviewDetails
                  .executedAppointments
                  .toInt()
                  .toString()),
          _buildReviewText(
              S.of(context).appointment_reviews_respected_appointments,
              provider.serviceProviderReview.serviceProviderReviewDetails
                  .respectedAppointments
                  .toInt()
                  .toString()),
          _buildReviewText(
              S.of(context).appointment_reviews_average_contact_response_time,
              '${provider.serviceProviderReview.serviceProviderReviewDetails.averageContactResponseTime.toString()} $contactResponseHour'),
          _buildReviewText(
              S.of(context).appointment_reviews_average_offer_response_time,
              '${provider.serviceProviderReview.serviceProviderReviewDetails.averageOfferResponseTime.toString()} $offerResponseHour'),
          _buildReviewText(S.of(context).appointment_reviews_global_efficiency,
              '${provider.serviceProviderReview.serviceProviderReviewDetails.globalEfficiency.toString()}%'),
        ],
      ),
    );
  }

  _buildReviewText(String title, String value) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextHelper.customTextStyle(color: gray2),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                value,
                style: TextHelper.customTextStyle(
                    color: black_text, weight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
