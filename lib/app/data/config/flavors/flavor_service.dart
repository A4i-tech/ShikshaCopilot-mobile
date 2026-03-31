import 'package:sikshana/app/data/config/flavors/base_config.dart';
import 'package:sikshana/app/data/config/flavors/dev_config.dart';
import 'package:sikshana/app/data/config/flavors/prod_config.dart';

/// Enum to represent different flavors
enum Flavor {
  /// Development flavor
  dev,

  /// Production flavor
  prod,
}

/// Service to manage and provide configuration based on the current flavor
class FlavorService {
  static Flavor? _flavor;

  /// Sets the current flavor
  static void setFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  /// Checks if the current flavor is development
  static bool isDev() => _flavor == Flavor.dev;

  /// Checks if the current flavor is production
  static bool isProd() => _flavor == Flavor.prod;

  /// Retrieves the configuration based on the current flavor
  static BaseConfig get config {
    switch (_flavor) {
      case Flavor.dev:
        return DevConfig();
      case Flavor.prod:
        return ProdConfig();
      default:
        throw Exception('Flavor not set');
    }
  }
}
