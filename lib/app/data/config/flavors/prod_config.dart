import 'package:sikshana/app/data/config/flavors/base_config.dart';

/// Production configuration implementation
class ProdConfig implements BaseConfig {
  //TODO: set prod urls
  // @override
  // String get apiHost => 'https://sikshana-backend.uat.pacewisdom.in/api';
  // @override
  // String get faqUrl => 'https://sikshana-backend.uat.pacewisdom.in/#/faq';

  @override
  String get apiHost => 'https://api.shikshacopilot.in/api';
  @override
  String get faqUrl => 'https://api.shikshacopilot.in/#/faq';
}
