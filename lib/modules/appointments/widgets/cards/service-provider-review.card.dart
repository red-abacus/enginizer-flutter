import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-client-review.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ServiceProviderReviewCard extends StatelessWidget {
  final ServiceProviderClientReview review;

  ServiceProviderReviewCard({this.review});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
        child: Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: new BorderRadius.circular(5.0),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              InkWell(
                splashColor: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                onTap: () => {},
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _leftReviewContainer(),
                      _rightReviewContainer(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _rightReviewContainer(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            _clientReviewRow(review.ratingCleaning,
                '(${S.of(context).appointment_client_rating_cleaning})'),
            _clientReviewRow(review.ratingKindness,
                '(${S.of(context).appointment_client_rating_kindness})'),
            _clientReviewRow(review.ratingReadiness,
                '(${S.of(context).appointment_client_rating_readiness})'),
          ],
        ));
  }

  _clientReviewRow(int value, String title) {
    return Container(
      child: Wrap(
        children: <Widget>[
          SvgPicture.asset(
            'assets/images/icons/star_icon.svg',
            semanticsLabel: 'Review Image',
            height: 14,
            width: 14,
          ),
          Container(
            margin: EdgeInsets.only(left: 4),
            child: Text(
              value.toString(),
              style:
                  TextHelper.customTextStyle(color: gray2, weight: FontWeight.bold, size: 12),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4),
            child: Text(
              title,
              style: TextHelper.customTextStyle(
                  color: gray2, size: 12),
            ),
          ),
        ],
      ),
    );
  }

  _leftReviewContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 10),
        alignment: Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${review.client?.name} - ${review.reviewDate}',
                style: TextHelper.customTextStyle(
                    color: black_text, weight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  review.feedback,
                  textAlign: TextAlign.left,
                  style: TextHelper.customTextStyle(color: gray2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
