import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/appointment/appointment-details.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/request/provider-review-request.model.dart';
import 'package:app/modules/appointments/providers/appointment.provider.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/shared/widgets/alert-confirmation-dialog.widget.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class AppointmentReviewModal extends StatefulWidget {
  final AppointmentDetail appointmentDetail;

  AppointmentReviewModal({this.appointmentDetail});

  @override
  _AppointmentReviewModalState createState() => _AppointmentReviewModalState();
}

class _AppointmentReviewModalState extends State<AppointmentReviewModal> {
  ProviderReviewRequest _request = new ProviderReviewRequest();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: .8,
      child: Container(
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(5.0),
          child: Container(
            decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: Theme(
              data: ThemeData(
                  accentColor: Theme.of(context).primaryColor,
                  primaryColor: Theme.of(context).primaryColor),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      padding: MediaQuery.of(context).viewInsets,
                      child: _getContent(),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  _getContent() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 60, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 40,
                        child: FadeInImage.assetNetwork(
                          image: widget.appointmentDetail.serviceProvider
                              .profilePhotoUrl,
                          placeholder: ServiceProvider.defaultImage(),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 4),
                    child: Text(
                      widget.appointmentDetail.serviceProvider.name,
                      style: TextHelper.customTextStyle(
                          color: gray3, weight: FontWeight.bold, size: 16),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  S.of(context).appointment_write_review_title,
                  style: TextHelper.customTextStyle(
                      color: gray3, weight: FontWeight.bold, size: 18),
                ),
              ),
              Text(
                S.of(context).appointment_write_review_body,
                style: TextHelper.customTextStyle(color: gray3, size: 18),
              ),
              _cleaningWidget(),
              _kindnessWidget(),
              _readinessWidget(),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Container(
                  child: Text(
                    S.of(context).appointment_write_review_feedback,
                    style: TextHelper.customTextStyle(
                        color: red, weight: FontWeight.bold, size: 16),
                  ),
                ),
              ),
              _feedbackWidget()
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: <Widget>[
                Spacer(),
                FlatButton(
                  color: red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: new Text(
                    S.of(context).general_save,
                    style: TextHelper.customTextStyle(
                        color: Colors.white,
                        weight: FontWeight.bold,
                        size: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    _submit();
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  _cleaningWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(
              S.of(context).appointment_client_rating_cleaning,
              style: TextHelper.customTextStyle(color: gray3, size: 16),
            ),
          ),
          RatingBar(
            initialRating: _request.cleaning,
            minRating: 1,
            direction: Axis.horizontal,
            unratedColor: Colors.amber.withAlpha(70),
            itemCount: 5,
            itemSize: 30.0,
            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _request.cleaning = rating;
              });
            },
          )
        ],
      ),
    );
  }

  _kindnessWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(
              S.of(context).appointment_client_rating_kindness,
              style: TextHelper.customTextStyle(color: gray3, size: 16),
            ),
          ),
          RatingBar(
            initialRating: _request.kindness,
            minRating: 1,
            direction: Axis.horizontal,
            unratedColor: Colors.amber.withAlpha(70),
            itemCount: 5,
            itemSize: 30.0,
            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _request.kindness = rating;
              });
            },
          )
        ],
      ),
    );
  }

  _readinessWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(
              S.of(context).appointment_client_rating_readiness,
              style: TextHelper.customTextStyle(color: gray3, size: 16),
            ),
          ),
          RatingBar(
            initialRating: _request.readiness,
            minRating: 1,
            direction: Axis.horizontal,
            unratedColor: Colors.amber.withAlpha(70),
            itemCount: 5,
            itemSize: 30.0,
            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _request.readiness = rating;
              });
            },
          )
        ],
      ),
    );
  }

  _feedbackWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        border: Border.all(
          color: gray2,
          width: 1.0,
        ),
      ),
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          onChanged: (value) {
            setState(() {
              _request.feedback = value;
            });
          },
        ),
      ),
    );
  }

  _submit() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return AlertConfirmationDialogWidget(
                confirmFunction: (confirm) {
                  if (confirm) {
                    _sendReview();
                  }
                },
                title: S.of(context).appointment_write_review_alert_title);
          });
        });
  }

  _sendReview() async {
    setState(() {
      _isLoading = true;
    });

    _request.providerId = widget.appointmentDetail.serviceProvider.id;
    AppointmentProvider _provider = Provider.of<AppointmentProvider>(context);
    try {
      _provider.writeReview(_request).then((value) {
        Navigator.pop(context);
      });
    } catch (error) {
      if (error
          .toString()
          .contains(ProviderService.WRITE_PROVIDER_REVIEW_EXCEPTION)) {
        FlushBarHelper.showFlushBar(S.of(context).general_error,
            S.of(context).exception_send_provider_review, context);
      }

      setState(() {
        _isLoading = false;
      });
    }
  }
}
