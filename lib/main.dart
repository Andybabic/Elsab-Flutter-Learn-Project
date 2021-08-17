import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';
import 'package:get_storage/get_storage.dart';



Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Map<String, int> orders = {};

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // initialRoute- Der Name der ersten anzuzeigenden Route, wenn ein Navigator erstellt wurde.
      initialRoute: AppRoutes.DASHBOARD,
      // Holt Wert von AppPages
      getPages: AppPages.list,
      // Debug false/true
      debugShowCheckedModeBanner: false,
      // Theme wird von der Hardware abgerufen
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
    );
  }
}
