class FirestoreLocation {
  double latitude;
  double longitude;
  int providerId;
  int appointmentId;

  FirestoreLocation(
      {this.latitude, this.longitude, this.providerId, this.appointmentId});

  factory FirestoreLocation.fromJson(Map<String, dynamic> json) {
    return FirestoreLocation(
        latitude: json['latitude'] != null ? json['latitude'] : null,
        longitude: json['longitude'] != null ? json['longitude'] : null,
        providerId:
            json['provider_id'] != null ? json['provider_id'] : null,
        appointmentId: json['appointment_id'] != null
            ? json['appointment_id']
            : null);
  }

  Map<String, dynamic> toJson() => {
        'latitude': this.latitude,
        'longitude': this.longitude,
        'provider_id': this.providerId,
        'appointment_id': this.appointmentId
      };
}
