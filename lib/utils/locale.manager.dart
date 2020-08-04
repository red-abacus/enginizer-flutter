import 'package:flutter/cupertino.dart';

class LocaleManager {
  static String language(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    return locale.languageCode == 'ro' ? locale.languageCode : 'en';
  }
}
