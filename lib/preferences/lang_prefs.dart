import 'package:flutter_weather/preferences/shared_prefs.dart';
import 'package:flutter_weather/localization.dart';

class LangPerfs {

  static Map<String, String> _langCodes = {
    'af': 'Afrikaans',
    'ar': 'Arabic',
    'az': 'Azerbaijani',
    'bg': 'Bulgarian',
    'ca': 'Catalan Valencian',
    'cs': 'Czech',
    'da': 'Danish',
    'de': 'German',
    'el': 'Modern Greek',
    'en': 'English',
    'es': 'Spanish Castilian',
    'eu': 'Basque',
    'fa': 'Persian',
    'fi': 'Finnish',
    'fr': 'French',
    'gl': 'Galician',
    'he': 'Hebrew',
    'hi': 'Hindi',
    'hr': 'Croatian',
    'hu': 'Hungarian',
    'id': 'Indonesian',
    'it': 'Italian',
    'ja': 'Japanese',
    'ko': 'Korean',
    'lt': 'Lithuanian',
    'lv': 'Latvian',
    'mk': 'Macedonian',
    'nl': 'Dutch Flemish',
    'no': 'Norwegian',
    'pl': 'Polish',
    'pt': 'Portuguese',
    'ro': 'Romanian Moldavian Moldovan',
    'ru': 'Russian',
    'sk': 'Slovak',
    'sl': 'Slovenian',
    'sq': 'Albanian',
    'sr': 'Serbian',
    'sv': 'Swedish',
    'th': 'Thai',
    'tr': 'Turkish',
    'uk': 'Ukrainian',
    'vi': 'Vietnamese',
    'zh': 'Chinese',
    'zu': 'Zulu',
  };

  static String _currentLangCode;


  static Future<void> initialise() async {
    _currentLangCode = "fr";//await SharedPrefs.getLanguageCode();
  }

  static void changeLangCode(String code) {
    _currentLangCode = code;
    SharedPrefs.setLanguageCode(code);
  }
  
  
  
  

  static String getLangString(String code) {
    return _langCodes[code];
    //returns the displayed name of the language code
  }
  
  static String getCurrentCode() {
    return _currentLangCode;
  }

  static List<String> langaugeCodes() {
    //returns all the keys of langCodes
    return _langCodes.keys;
  }

  static String getTranslation(String key) {
    //returns the translation of the value of the key in localizations.dart

    return localizedValues[_currentLangCode][key];
  }
}
