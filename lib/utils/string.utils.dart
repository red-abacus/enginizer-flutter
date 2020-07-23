class StringUtils {

  static bool containsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase()?.contains(string2?.toLowerCase());
  }

  static bool registrationNumberMatches(String sender) {
    RegExp regExp = RegExp(r'([A-Z]{1}[0-9]{2})/([0-9]{4})/([0-9]{4})$');
    return regExp.hasMatch(sender);
  }
}
