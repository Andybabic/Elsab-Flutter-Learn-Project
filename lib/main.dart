import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'constants/app_constants.dart';
import 'components/AppStatus.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AppStatusManager());
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

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
      theme: ThemeConst.lightTheme,
      darkTheme: ThemeConst.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
