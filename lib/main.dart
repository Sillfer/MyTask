import 'package:flutter/material.dart';
import 'package:flutter_notification/services/theme_services.dart';
import 'package:flutter_notification/ui/homePage.dart';
import 'package:flutter_notification/ui/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // color: Theme.of(context).primaryColor,
      title: 'Task Management App',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,

      home: const HomePage(),
      builder: EasyLoading.init(),
    );
  }
}
