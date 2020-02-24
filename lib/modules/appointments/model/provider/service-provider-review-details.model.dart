class ServiceProviderReviewDetails {
  double executedAppointments;
  double respectedAppointments;
  double averageContactResponseTime;
  double averageOfferResponseTime;
  double globalEfficiency;

  ServiceProviderReviewDetails(
      {this.executedAppointments,
      this.respectedAppointments,
      this.averageContactResponseTime,
      this.averageOfferResponseTime,
      this.globalEfficiency});

  factory ServiceProviderReviewDetails.fromJson(Map<String, dynamic> json) {
    return ServiceProviderReviewDetails(
        executedAppointments: json['executedAppointments'],
        respectedAppointments: json['respectedAppointments'],
        averageContactResponseTime: json['averageContactResponseTime'],
        averageOfferResponseTime: json['averageOfferResponseTime'],
        globalEfficiency: json['globalEfficiency']);
  }
}
