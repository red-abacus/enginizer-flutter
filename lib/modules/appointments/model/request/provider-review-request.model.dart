class ProviderReviewRequest {
  double cleaning = 3;
  double kindness = 3;
  double readiness = 3;
  String feedback = '';
  int providerId;

  Map<String, dynamic> toJson() => {
    'feedback': feedback,
    'ratingCleaning': cleaning.toInt(),
    'ratingKindness': kindness.toInt(),
    'ratingReadiness': readiness.toInt(),
  };
}