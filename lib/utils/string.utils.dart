class StringUtils {

  static bool containsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase()?.contains(string2?.toLowerCase());
  }

  static String _registrationNoRegex = '([A-Z][1-9]{2})\/([1-9]{4})\/([1-9]{4})\/([1-9]{4})';

  static bool registrationNumberMatches(String sender) {
    RegExp regExp = RegExp(_registrationNoRegex);
    return regExp.hasMatch(sender);
  }
}
