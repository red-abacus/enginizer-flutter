class ServiceProviderClient {
  int id;
  String name;
  String email;
  String phoneNumber;
  int providerId;
  bool active;

  ServiceProviderClient(
      {this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.providerId,
      this.active});

  factory ServiceProviderClient.fromJson(Map<String, dynamic> json) {
    return ServiceProviderClient(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'] != null ? json['phoneNumber'] : '',
      providerId: json['providerId'],
      active: json['active']
    );
  }
}
