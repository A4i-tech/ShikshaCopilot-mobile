import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:sikshana/app/data/local/store/local_store.dart';
import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Helper class for local stored User
class UserProvider {
  static User? _user;
  static String? _authToken;
  static late bool _isLoggedIn;

  /// Get currently logged in user
  static User? get currentUser => _user;

  /// Get auth token of the logged in user
  static String? get authToken => _authToken;

  /// If the user is logged in or not
  static bool get isLoggedIn => _isLoggedIn;

  ///Set [currentUser] and [authToken]
  static Future<void> onLogin(
    User user,
    String userAuthToken,
    String language,
  ) async {
    _isLoggedIn = true;
    _user = user;
    _authToken = userAuthToken;
    LocalStore.user(json.encode(user.toJson()));
    LocalStore.authToken(userAuthToken);
    LocalStore.currentLocale(language);
    await Get.updateLocale(Locale(language));
  }

  ///updates [currentUser]
  static set currentUser(User user) {
    _user = user;
  }

  ///get user initials
  static String getUserInitials() {
    final List<String> words = (_user?.name ?? '').split(' ')
      ..removeWhere((String word) => word.isEmpty);

    if (words.length == 1) {
      return words.first.substring(0, 1);
    } else if (words.length >= 2) {
      return words.first.substring(0, 1) + words.last.substring(0, 1);
    }

    return '';
  }

  ///Load [currentUser] and [authToken]
  static void loadUser() {
    final String? encryptedUserData = LocalStore.user();

    if (encryptedUserData != null) {
      _isLoggedIn = true;
      _user = User.fromJson(
        jsonDecode(encryptedUserData) as Map<String, dynamic>,
      );
      _authToken = LocalStore.authToken();
    } else {
      _isLoggedIn = false;
    }
  }

  ///Remove [currentUser] and [authToken] from local storage
  static Future<void> onLogout() async {
    _isLoggedIn = false;
    _user = null;
    _authToken = null;
    LocalStore.user.erase();
    LocalStore.authToken.erase();
    Get
      ..delete<HomeController>(force: true)
      ..delete<ContentGenerationController>(force: true)
      ..delete<ProfileController>(force: true)
      ..delete<ChatbotController>(force: true)
      ..delete<AuthController>(force: true)
      ..offAllNamed(Routes.AUTH, predicate: (Route<dynamic> route) => false);
  }
}
