import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color blueClr = Color.fromARGB(255, 25, 117, 192);
const Color yellowClr = Color.fromARGB(255, 230, 154, 33);
const Color darkYellowClr = Color(0xffF57F17);
const Color pinkClr = Color.fromARGB(255, 196, 56, 102);
const Color darkP = Color(0xffC2185B);
const Color darkBlueClr = Color(0xff0D47A1);
const Color whiteClr = Color(0xffFFFFFF);
const primaryClr = blueClr;
const Color darkGreyClr = Color(0xff212121);
const Color darkHeaderClr = Color(0xff424242);

class Themes {
  static final light = ThemeData(
    // backgroundColor: Colors.red,
    primaryColor: primaryClr,
    brightness: Brightness.light,

    colorScheme: ColorScheme(
      primary: Color(0xFF3F51B5),
      // primaryVariant: Color(0xFF303F9F),
      secondary: Color(0xFFEC407A),
      // secondaryVariant: Color(0xFFC2185B),
      surface: Colors.white,
      background: Colors.white,
      error: Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );
  static final dark = ThemeData(
    colorScheme: ColorScheme(
      primary: Color(0xFF7986CB),
      // primaryVariant: Color(0xFF5C6BC0),
      secondary: Color(0xFFE91E63),
      // secondaryVariant: Color(0xFFC2185B),
      surface: Color(0xFF121212),
      background: Color(0xFF121212),
      error: Color(0xFFCF6679),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.grey[300] : Colors.grey,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.white : Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  );
}


TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );
}