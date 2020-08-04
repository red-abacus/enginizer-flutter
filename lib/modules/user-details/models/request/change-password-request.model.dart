class ChangePasswordRequest {
  String currentPassword = '';
  String newPassword = '';
  String confirmNewPassword = '';

  ChangePasswordRequest({userId});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'confirmPassword': confirmNewPassword,
      'currentPassword': currentPassword,
      'password': newPassword
    };

    return propMap;
  }

  isValid() {
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) {
      return false;
    }

    if (currentPassword.length < 6 || newPassword.length < 6 || confirmNewPassword.length < 6) {
      return false;
    }

    if (newPassword != confirmNewPassword) {
      return false;
    }

    return true;
  }
}
