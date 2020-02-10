class StringUtils {

  static bool containsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase()?.contains(string2?.toLowerCase());
  }
}
