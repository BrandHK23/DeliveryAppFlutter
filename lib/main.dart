import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/pages/client/products/list/client_products_list_page.dart';
import 'package:iris_delivery_app_stable/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:iris_delivery_app_stable/src/pages/login/login_page.dart';
import 'package:iris_delivery_app_stable/src/pages/register/register_page.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:iris_delivery_app_stable/src/pages/roles/roles_page.dart';

import 'package:iris_delivery_app_stable/src/utils/my_colors.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // Remove the debug banner
        title: 'Delivery App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'register': (BuildContext context) => RegisterPage(),
          'roles': (BuildContext context) => RolesPage(),
          'client/product/list': (BuildContext context) => ClientProductsListPage(),
          'restaurant/orders/list': (BuildContext context) => RestaurantOrdersListPage(),
          'delivery/orders/list': (BuildContext context) => DeliveryOrdersListPage(),
        },
        theme: ThemeData(
          primaryColor: MyColors.primaryColor,
          fontFamily: 'NimbusSans',
        )
    );
  }
}