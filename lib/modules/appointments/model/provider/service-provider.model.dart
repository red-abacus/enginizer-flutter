import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-rating.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider-timetable.model.dart';
import 'package:app/modules/authentication/models/user-provider-schedule.model.dart';

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
  bool isVATPayer;
  List<UserProviderSchedule> userProviderSchedules;

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
      this.rating,
      this.isVATPayer,
      this.userProviderSchedules});

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
        image: json['image'] != null
            ? json['image']
            : json['imageUrl'] != null ? json['imageUrl'] : '',
        rating: json["ratingDto"] != null
            ? ServiceProviderRating.fromJson(json["ratingDto"])
            : null,
        isVATPayer: json['isVATPayer'] != null ? json['isVATPayer'] : true,
        userProviderSchedules: json['schedule'] != null ? _mapUserProviderSchedules(json['schedule']) : []);
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

  static _mapUserProviderSchedules(List<dynamic> list) {
    List<UserProviderSchedule> userProviderSchedules = [];

    if (list != null) {
      list.forEach((item) {
        UserProviderSchedule schedule = UserProviderSchedule.fromJson(item);

        if (schedule != null) {
          userProviderSchedules.add(schedule);
        }
      });
    }

    return userProviderSchedules;
  }

  static String defaultImage() {
    return 'assets/images/defaults/default_service_provider.jpg';
  }
}
