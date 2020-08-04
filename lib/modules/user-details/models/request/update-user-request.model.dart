import 'package:app/modules/authentication/models/jwt-user-details.model.dart';

class UpdateUserRequest {
  String name = '';
  String address = '';
  String phoneNumber = '';
  int userId;

  UpdateUserRequest({this.name, this.address, this.phoneNumber, this.userId});

  factory UpdateUserRequest.fromUserDetails(JwtUserDetails userDetails) {
    return UpdateUserRequest(
        name: userDetails?.name ?? '',
        address: userDetails?.homeAddress ?? '',
        phoneNumber: userDetails?.phoneNumber,
        userId: userDetails?.id);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'name': name,
      'homeAddress': address,
      'phoneNo': phoneNumber
    };

    return propMap;
  }
}
