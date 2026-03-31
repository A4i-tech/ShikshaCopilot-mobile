import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:sikshana/generated/locales.g.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
    'en': Locales.en,
    'kn': Locales.kn,
  };
}
