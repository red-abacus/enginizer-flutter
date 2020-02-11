class ServiceProviderTimeSerie {
  int id;
  String hour;
  String slotStatus;

  ServiceProviderTimeSerie({this.id, this.hour, this.slotStatus});

  factory ServiceProviderTimeSerie.fromJson(Map<String, dynamic> json) {
    return ServiceProviderTimeSerie(
        id: json['id'], hour: json['hour'], slotStatus: json['slotStatus']);
  }
}
