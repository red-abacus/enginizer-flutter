import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-item.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-rating.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-timetable.model.dart';

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
  ServiceProviderRating rating;

  List<ServiceProviderItem> items = [];
  List<ServiceProviderTimetable> timetables = [];

  ServiceProvider(
      {this.id,
      this.name,
      this.address,
      this.contactPerson,
      this.cui,
      this.fiscalName,
      this.profilePhotoUrl,
      this.registrationNumber,
      this.image,
      this.rating});

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
        id: json['id'],
        name: json['name'] != null ? json["name"] : "",
        address: json['address'] != null ? json['address'] : "",
        cui: json['cui'] != null ? json['cui'] : "",
        fiscalName: json['fiscalName'] != null ? json['fiscalName'] : "",
        profilePhotoUrl:
            json['profilePhotoUrl'] != null ? json['profilePhotoUrl'] : "",
        registrationNumber: json['registrationNumber'] != null
            ? json['registrationNumber']
            : "",
        image: json['image'] != null ? json['image'] : "",
        rating: json["ratingDto"] != null
            ? ServiceProviderRating.fromJson(json["ratingDto"])
            : null);
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
