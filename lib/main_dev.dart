import 'package:sikshana/app/data/config/flavors/flavor_service.dart';
import 'package:sikshana/main.dart' as app;

void main() {
  FlavorService.setFlavor(Flavor.dev);
  app.main();
}
