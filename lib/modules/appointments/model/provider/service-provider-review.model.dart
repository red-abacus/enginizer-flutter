import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-client-review.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-rating.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-review-details.model.dart';

class ServiceProviderReview {
  ServiceProviderRating serviceProviderRating;
  ServiceProviderReviewDetails serviceProviderReviewDetails;
  List<ServiceProviderClientReview> clientReviews;

  ServiceProviderReview(
      {this.serviceProviderRating,
      this.serviceProviderReviewDetails,
      this.clientReviews});

  factory ServiceProviderReview.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> review = json['review'];

    return ServiceProviderReview(
        serviceProviderRating: json['rating'] != null
            ? ServiceProviderRating.fromJson(json['rating'])
            : null,
        serviceProviderReviewDetails: review['reviewDetails'] != null
            ? ServiceProviderReviewDetails.fromJson(review['reviewDetails'])
            : null,
        clientReviews: _mapClientReviews(review['reviews']));
  }

  static _mapClientReviews(List<dynamic> response) {
    List<ServiceProviderClientReview> clientReviews = [];

    response.forEach((item) {
      clientReviews.add(ServiceProviderClientReview.fromJson(item));
    });

    return clientReviews;
  }
}
