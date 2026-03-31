import 'package:sikshana/app/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';

///LaunchUrl class
class LaunchUrl {
  LaunchUrl._();

  ///function to launch url
  static Future<void> launch(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: mode);
      } else {
        logE('error url_launcher:$url');
      }
    } on Exception catch (e) {
      logE('error url_launcher:$e');
    }
  }
}
