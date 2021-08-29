import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:elsab/components/class_user.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'constants/app_constants.dart';
import 'components/AppStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AppStatusManager());
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //await GetStorage.init();
  //User().ReadUserOnDevice();
  lonincheck();
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


lonincheck() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool Userexist = (prefs.getBool('UserExist') ?? false);
  true;

  if (Userexist) {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }else{
    print('wrong');
  }
}
