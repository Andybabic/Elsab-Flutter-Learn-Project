import 'package:get/get.dart';
import 'package:elsab/pages/dashboard/dashboard_binding.dart';
import 'package:elsab/pages/dashboard/dashboard_screen.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
  ];
}
