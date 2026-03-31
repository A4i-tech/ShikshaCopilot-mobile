import 'package:sikshana/app/utils/exports.dart';

class AppThemes {
  AppThemes._();

  // New Theme Colors based on Dashboard.png and Menus.jpg
  static const Color primary =
      AppColors.k46A0F1; // Main blue for buttons and highlights
  static const Color secondary = AppColors.kED7D2D; // Purple for some buttons
  static const Color background = AppColors.kFFFFFF; // Light grey background
  static const Color card = AppColors.kFFFFFF; // White for cards
  static const Color text = AppColors.k171A1F; // For headings
  static const Color textSecondary = AppColors.k171A1F; // For body text
  static const Color textLight = AppColors.k171A1F; // For lighter text
  static const Color drawerSelection =
      AppColors.kEDF6FE; // Drawer selected item background
  static const Color green = Color(0xFF65D5A4);
  static const Color orange = Color(0xFFFFA88C);
  static const Color blue = Color(0xFF529CFF);
  static const Color purple = Color(0xFFAD8CFF);
  static const Color error = Color(0xFFFF6188);
  static const Color success = Color(0xFFBAD761);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color nevada = Color.fromRGBO(105, 109, 119, 1);
  static const Color ebonyClay = Color.fromRGBO(40, 42, 58, 1);
  static const Color blackPearl = Color.fromRGBO(30, 31, 43, 1);

  static String font1 = AppFonts.lato;

  //constants color range for light theme
  //main color
  static const Color _lightPrimaryColor = primary;

  //Background Colors
  static const Color _lightBackgroundColor = background;
  static const Color _lightBackgroundAppBarColor = background;
  static const Color _lightBackgroundSecondaryColor = card;
  static const Color _lightBackgroundAlertColor = blackPearl;
  static const Color _lightBackgroundActionTextColor = white;
  static const Color _lightBackgroundErrorColor = error;
  static const Color _lightBackgroundSuccessColor = success;

  //Text Colors
  static const Color _lightTextColor = text;
  static const Color _lightAlertTextColor = text;
  static const Color _lightTextSecondaryColor = textSecondary;

  //Border Color
  static const Color _lightBorderColor = nevada;

  //Icon Color
  static const Color _lightIconColor = textSecondary;

  //form input colors
  static const Color _lightInputFillColor = _lightBackgroundSecondaryColor;
  static const Color _lightBorderActiveColor = _lightPrimaryColor;
  static const Color _lightBorderErrorColor = error;

  //constants color range for dark theme
  static const Color _darkPrimaryColor = primary;

  //Background Colors
  static const Color _darkBackgroundColor = ebonyClay;
  static const Color _darkBackgroundAppBarColor = _darkPrimaryColor;
  static const Color _darkBackgroundSecondaryColor = Color.fromRGBO(
    0,
    0,
    0,
    .6,
  );
  static const Color _darkBackgroundAlertColor = blackPearl;
  static const Color _darkBackgroundActionTextColor = white;

  static const Color _darkBackgroundErrorColor = error;
  static const Color _darkBackgroundSuccessColor = success;

  //Text Colors
  static const Color _darkTextColor = Colors.white;
  static const Color _darkAlertTextColor = Colors.black;
  static const Color _darkTextSecondaryColor = Colors.black;

  //Border Color
  static const Color _darkBorderColor = nevada;

  //Icon Color
  static const Color _darkIconColor = nevada;

  static const Color _darkInputFillColor = _darkBackgroundSecondaryColor;
  static const Color _darkBorderActiveColor = _darkPrimaryColor;
  static const Color _darkBorderErrorColor = error;

  //text theme for light theme
  static const TextTheme _lightTextTheme = TextTheme(
    bodyMedium: TextStyle(
      fontSize: 16,
      color: _lightTextColor,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: _lightTextColor,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: _lightTextSecondaryColor,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      color: _lightTextColor,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: TextStyle(
      fontSize: 12,
      color: _lightTextSecondaryColor,
      fontWeight: FontWeight.w400,
    ),
    displayLarge: TextStyle(
      fontSize: 24,
      color: _lightTextColor,
      fontWeight: FontWeight.w700,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      color: _lightTextSecondaryColor,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      fontSize: 24,
      color: _lightTextColor,
      fontWeight: FontWeight.w700,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      color: _lightTextColor,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      fontSize: 18,
      color: _lightTextColor,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: TextStyle(
      fontSize: 16,
      color: _lightTextColor,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      color: _lightTextColor,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      color: _lightTextColor,
      fontWeight: FontWeight.w700,
    ),
    labelLarge: TextStyle(
      fontSize: 18,
      color: _lightTextColor,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      color: _lightTextColor,
      fontWeight: FontWeight.w700,
    ),
  );

  //the light theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: font1,
    scaffoldBackgroundColor: _lightBackgroundColor,
    primaryColor: _lightPrimaryColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _lightPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: _lightBackgroundAppBarColor,
      iconTheme: IconThemeData(color: _lightTextColor),
      titleTextStyle: TextStyle(
        color: _lightTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: _lightPrimaryColor,
      secondary: secondary,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: _lightBackgroundAlertColor,
      actionTextColor: _lightBackgroundActionTextColor,
    ),
    iconTheme: const IconThemeData(color: _lightIconColor),
    popupMenuTheme: const PopupMenuThemeData(
      color: _lightBackgroundAppBarColor,
    ),
    textTheme: _lightTextTheme,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      buttonColor: _lightPrimaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    unselectedWidgetColor: _lightPrimaryColor,
    inputDecorationTheme: const InputDecorationTheme(
      //prefixStyle: TextStyle(color: _lightIconColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightBorderActiveColor),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightBorderErrorColor),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _lightBorderErrorColor),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      fillColor: _lightInputFillColor,
      //focusColor: _lightBorderActiveColor,
    ),
  );

  //text theme for dark theme
  /*static final TextStyle _darkScreenHeadingTextStyle =
      _lightScreenHeadingTextStyle.copyWith(color: _darkTextColor);
  static final TextStyle _darkScreenTaskNameTextStyle =
      _lightScreenTaskNameTextStyle.copyWith(color: _darkTextColor);
  static final TextStyle _darkScreenTaskDurationTextStyle =
      _lightScreenTaskDurationTextStyle;
  static final TextStyle _darkScreenButtonTextStyle = TextStyle(
      fontSize: 14.0, color: _darkTextColor, fontWeight: FontWeight.w500);
  static final TextStyle _darkScreenCaptionTextStyle = TextStyle(
      fontSize: 12.0,
      color: _darkBackgroundAppBarColor,
      fontWeight: FontWeight.w100);*/

  static const TextTheme _darkTextTheme = TextTheme(
    bodyMedium: TextStyle(fontSize: 16, color: _darkTextColor),
    bodyLarge: TextStyle(fontSize: 18, color: _darkTextColor),
    bodySmall: TextStyle(fontSize: 14, color: _darkTextColor),
    headlineMedium: TextStyle(fontSize: 20, color: _darkTextColor),
    displaySmall: TextStyle(fontSize: 12, color: _darkTextColor),
    displayLarge: TextStyle(fontSize: 24, color: _darkTextColor),
    labelSmall: TextStyle(fontSize: 10, color: _darkTextColor),
    titleLarge: TextStyle(fontSize: 24, color: _darkTextColor),
    labelMedium: TextStyle(fontSize: 14, color: _darkTextColor),
    titleSmall: TextStyle(fontSize: 18, color: _darkTextColor),
    displayMedium: TextStyle(fontSize: 16, color: _darkTextColor),
    headlineLarge: TextStyle(fontSize: 24, color: _darkTextColor),
    headlineSmall: TextStyle(fontSize: 18, color: _darkTextColor),
    labelLarge: TextStyle(fontSize: 18, color: _darkTextColor),
    titleMedium: TextStyle(fontSize: 20, color: _darkTextColor),
  );

  //the dark theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    //primarySwatch: _darkPrimaryColor, //cant be Color on MaterialColor so it can compute different shades.
    //prefix icon color form input on focus
    fontFamily: font1,
    scaffoldBackgroundColor: _darkBackgroundColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _darkPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      color: _darkBackgroundAppBarColor,
      iconTheme: IconThemeData(color: _darkTextColor),
    ),
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: secondary,
    ),
    snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(color: Colors.white),
      backgroundColor: _darkBackgroundAlertColor,
      actionTextColor: _darkBackgroundActionTextColor,
    ),
    iconTheme: const IconThemeData(
      color: _darkIconColor, //_darkIconColor,
    ),
    popupMenuTheme: const PopupMenuThemeData(color: _darkBackgroundAppBarColor),
    textTheme: _darkTextTheme,
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      buttonColor: _darkPrimaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    unselectedWidgetColor: _darkPrimaryColor,
    inputDecorationTheme: const InputDecorationTheme(
      prefixStyle: TextStyle(color: _darkIconColor),
      //labelStyle: TextStyle(color: nevada),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkBorderColor),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkBorderActiveColor),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkBorderErrorColor),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: _darkBorderErrorColor),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      fillColor: _darkInputFillColor,
      //focusColor: _darkBorderActiveColor,
    ),
  );
}
