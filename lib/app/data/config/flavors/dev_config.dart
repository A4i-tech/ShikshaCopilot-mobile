import 'package:sikshana/app/data/config/flavors/base_config.dart';

/// Development configuration implementation
class DevConfig implements BaseConfig {
  @override
  String get apiHost => 'https://sikshana-backend.pacewisdom.in/api';

  @override
  String get faqUrl => 'https://sikshana.pacewisdom.in/#/faq';
}
