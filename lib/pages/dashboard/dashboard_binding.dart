import 'package:get/get.dart';
import 'package:elsab/controller/account_controller.dart';
import 'package:elsab/controller/home_controller.dart';
import '../../controller/dashboard_controller.dart';


class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AccountController>(() => AccountController());

    //Get.lazyPut<OrderItem>(() => OrderItem('nothing'));
    
  }
}
