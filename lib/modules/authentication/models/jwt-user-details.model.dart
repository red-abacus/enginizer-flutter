import 'package:app/modules/authentication/models/user-provider.model.dart';
import 'package:app/modules/authentication/models/user-role.model.dart';
import 'package:app/modules/consultant-user-details/screens/user-details-consultant.dart';

class JwtUserDetails {
  int id;
  String name;
  String email;
  UserRole userRole;
  UserProvider userProvider;
  String phoneNumber;
  String userType;
  bool active;

  JwtUserDetails(
      {this.id,
      this.name,
      this.email,
      this.userRole,
      this.userProvider,
      this.phoneNumber,
      this.userType,
      this.active});

  factory JwtUserDetails.fromJson(Map<String, dynamic> json) {
    print('user details json $json');
    return JwtUserDetails(
      id: json['id'],
      name: json['name'] != null ? json['name'] : "",
      email: json['email'] != null ? json['email'] : "",
      userRole: json['role'] != null ? UserRole.fromJson(json['role']) : null,
      userProvider: json['provider'] != null ? UserProvider.fromJson(json['provider']) : null,
      phoneNumber: json['phoneNumber'] != null ? json['phoneNumber'] : "",
      userType: json['userType'] != null ? json['userType'] : "",
      active: json['active'] != null ? json['active'] : false,
    );
  }
}
