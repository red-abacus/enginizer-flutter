import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.dart';

class ServiceProvider {
  int id;
  String name;
  String address;
  String contactPerson;
  String cui;
  String fiscalName;
  String profilePhotoUrl;
  String registrationNumber;
  String image;

  List<ServiceProviderItem> items = [];

  ServiceProvider(
      {this.id,
      this.name,
      this.address,
      this.contactPerson,
      this.cui,
      this.fiscalName,
      this.profilePhotoUrl,
      this.registrationNumber,
      this.image});

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      cui: json['cui'],
      fiscalName: json['fiscalName'],
      profilePhotoUrl: json['profilePhotoUrl'],
      registrationNumber: json['registrationNumber'],
      image: json['image']
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'id': id,
      'name': name,
      'address': address,
      'cui': cui,
      'fiscalName': fiscalName,
      'profilePhotoUrl': profilePhotoUrl,
      'registrationNumber': registrationNumber,
      'image': image
    };

    return propMap;
  }
}
