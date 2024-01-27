import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/business.dart';
import 'package:iris_delivery_app_stable/src/models/order.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:iris_delivery_app_stable/src/provider/orders_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RestaurantOrdersListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Function refresh;
  User user;
  Business business;

  bool isUpdated;

  List<String> status = ['CREATED', 'PREPARED', 'SENT', 'DELIVERED'];
  OrdersProviders _ordersProviders = new OrdersProviders();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read("user"));

    await loadBusinessData(); // Asegúrate de cargar los datos del negocio aquí

    _ordersProviders.init(context, user);
    refresh(); // Actualiza la UI después de cargar los datos
  }

  Future<void> loadBusinessData() async {
    String businessJson = await _sharedPref.read("business");
    if (businessJson != null) {
      Map<String, dynamic> businessMap = json.decode(businessJson);
      this.business = Business.fromJson(businessMap);
      print(
          "Business data loaded: ${this.business.toJson()}"); // Agregar para depuración
    } else {
      print("Business data not loaded"); // Agregar para depuración
    }
  }

  Future<List<Order>> getOrders(String status) async {
    return await _ordersProviders.getByStatus(status);
  }

  void openBottomSheet(Order order) async {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => RestaurantOrdersDetailPage(order: order));
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
