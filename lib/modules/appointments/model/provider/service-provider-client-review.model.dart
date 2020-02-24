import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-client.model.dart';

class ServiceProviderClientReview {
  ServiceProviderClient client;
  String feedback;
  String reviewDate;
  int ratingCleaning;
  int ratingKindness;
  int ratingReadiness;

  ServiceProviderClientReview(
      {this.client,
      this.feedback,
      this.reviewDate,
      this.ratingCleaning,
      this.ratingKindness,
      this.ratingReadiness});

  factory ServiceProviderClientReview.fromJson(Map<String, dynamic> json) {
    return ServiceProviderClientReview(
        client: json['client'] != null
            ? ServiceProviderClient.fromJson(json['client'])
            : null,
        feedback: json['feedback'],
        reviewDate: json['reviewDate'],
        ratingCleaning: json['ratingCleaning'],
        ratingKindness: json['ratingKindness'],
        ratingReadiness: json['ratingReadiness']);
  }
}
