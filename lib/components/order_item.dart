import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';


class OrderItem  extends GetxController{
  final order = GetStorage();

  String product;
  int count = 0;

  OrderItem(this.product );


  clearAll() {

    order.erase();
    update();
  }

  getCount() {
    if (order.read(product) == null) {
      order.write(product, 0);
      return order.read(product);
    }

    return order.read(product);
  }

  addCount() {
    int count = order.read(product);
    count++;
    order.write(product, count);
    update();
  }

  reduceCount() {
    int count = order.read(product);
    count--;
    order.write(product, count);
    update();
  }
}
