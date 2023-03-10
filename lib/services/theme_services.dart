import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices {
  final _box = GetStorage();
  final _key = 'isDarkMode'; // key to store in box

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  bool _loadThemeFromBox() =>
      _box.read(_key) ?? false; // default value is false
  ThemeMode get theme => _loadThemeFromBox()
      ? ThemeMode.dark // if true then dark mode
      : ThemeMode.light; // if false then light mode

  void switchTheme() {
    Get.changeThemeMode(
        _loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark); // change theme
    _saveThemeToBox(!_loadThemeFromBox()); // save theme
  }
}
