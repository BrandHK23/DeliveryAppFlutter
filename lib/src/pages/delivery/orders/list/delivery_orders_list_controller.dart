import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/order.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/pages/delivery/orders/detail/delivery_orders_detail_page.dart';
import 'package:iris_delivery_app_stable/src/provider/orders_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DeliveryOrdersListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Function refresh;
  User user;

  bool isUpdated;

  List<String> status = ['PREPARED', 'SENT', 'DELIVERED'];
  OrdersProviders _ordersProviders = new OrdersProviders();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read("user"));

    _ordersProviders.init(context, user);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    if (user == null) {
      // Manejo del caso cuando user es null
      return []; // Por ejemplo, retornar una lista vacía
    }
    return await _ordersProviders.getByDeliveryAndStatus(user.id, status);
  }

  void openBottomSheet(Order order) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => DeliveryOrdersDetailPage(order: order));
    if (isUpdated ?? false) {
      refresh();
    }
  }

  void logout() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToCategoryCreate() {
    Navigator.pushNamed(context, 'restaurant/categories/create');
  }

  void goToProductCreate() {
    Navigator.pushNamed(context, 'restaurant/products/create');
  }
}
