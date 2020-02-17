class ServiceProviderRating {
  double value;
  int reviews;

  ServiceProviderRating(
      {this.value,
        this.reviews});

  factory ServiceProviderRating.fromJson(Map<String, dynamic> json) {
    return ServiceProviderRating(
        value: json['value'],
        reviews: json['reviews']
    );
  }
}