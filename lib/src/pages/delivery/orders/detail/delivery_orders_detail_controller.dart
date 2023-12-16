import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iris_delivery_app_stable/src/models/order.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/orders_providers.dart';
import 'package:iris_delivery_app_stable/src/provider/users_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class DeliveryOrdersDetailController {
  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();

  double total = 0;
  Order order;

  User user;
  List<User> users = [];
  UsersProviders _usersProviders = new UsersProviders();
  OrdersProviders _ordersProviders = new OrdersProviders();
  String idDelivery;

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProviders.init(context, sessionUser: user);
    _ordersProviders.init(context, user);

    getTotal();
    getUsers();
    refresh();
  }

  void updateOrder() async {
    ResponseApi responseApi = await _ordersProviders.updateToOnTheWay(order);
    Fluttertoast.showToast(
        msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
    if (responseApi.success) {
      Navigator.pushNamed(context, 'delivery/orders/map',
          arguments: order.toJson());
    }
  }

  void getUsers() async {
    users = await _usersProviders.getDeliveryMen();
    refresh();
  }

  void getTotal() {
    total = 0;
    order.products.forEach((product) {
      total += product.price * product.quantity;
    });

    refresh();
  }
}
