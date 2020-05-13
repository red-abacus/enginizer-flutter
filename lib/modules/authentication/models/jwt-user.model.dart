class JwtUser {
  int userId;
  String email;
  String jti;
  String iss;
  dynamic sub;
  String given_name;
  String badgeId;
  String role;
  List<dynamic> permissions;
  dynamic userType;
  int providerId;
  int exp;
  String aud;

  JwtUser(
      {this.userId,
      this.email,
      this.jti,
      this.iss,
      this.sub,
      this.given_name,
      this.badgeId,
      this.role,
      this.permissions,
      this.userType,
      this.providerId,
      this.exp,
      this.aud});

  factory JwtUser.fromJson(Map<String, dynamic> json) {
    print('jwt user $json');
    return JwtUser(
        userId: json['userId'],
        email: json['email'],
        sub: json['sub'],
        role: json['role'],
        permissions: json['permissions'],
        userType: json['userType'],
        providerId: json['providerId']);
  }
}
