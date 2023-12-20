import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/pages/client/address/create/client_address_create_page.dart';
import 'package:iris_delivery_app_stable/src/pages/client/address/list/client_address_list_page.dart';
import 'package:iris_delivery_app_stable/src/pages/client/address/map/client_address_map_page.dart';
import 'package:iris_delivery_app_stable/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:iris_delivery_app_stable/src/pages/client/orders/list/client_orders_list_page.dart';
import 'package:iris_delivery_app_stable/src/pages/client/orders/map/client_orders_map_page.dart';
import 'package:iris_delivery_app_stable/src/pages/client/products/list/client_products_list_page.dart';
import 'package:iris_delivery_app_stable/src/pages/client/update/client_update_page.dart';
import 'package:iris_delivery_app_stable/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:iris_delivery_app_stable/src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:iris_delivery_app_stable/src/pages/login/login_page.dart';
import 'package:iris_delivery_app_stable/src/pages/register/register_page.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/category/create/restaurant_categories_create_page.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:iris_delivery_app_stable/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
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
        debugShowCheckedModeBanner: false,
        // Remove the debug banner
        title: 'Delivery App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'register': (BuildContext context) => RegisterPage(),
          'roles': (BuildContext context) => RolesPage(),
          'client/products/list': (BuildContext context) =>
              ClientProductsListPage(),
          'client/update': (BuildContext context) => ClientUpdatePage(),
          'client/orders/create': (BuildContext context) =>
              ClientOrdersCreatePage(),
          'client/orders/list': (BuildContext context) =>
              ClientOrdersListPage(),
          'client/orders/map': (BuildContext context) => ClientOrdersMapPage(),
          'client/address/list': (BuildContext context) =>
              ClientAddressListPage(),
          'client/address/create': (BuildContext context) =>
              ClientAddressCreatePage(),
          'client/address/map': (BuildContext context) =>
              ClientAddressMapPage(),
          'restaurant/orders/list': (BuildContext context) =>
              RestaurantOrdersListPage(),
          'restaurant/categories/create': (BuildContext context) =>
              RestaurantCategoriesCreatePage(),
          'restaurant/products/create': (BuildContext context) =>
              RestaurantProductsCreatePage(),
          'delivery/orders/list': (BuildContext context) =>
              DeliveryOrdersListPage(),
          'delivery/orders/map': (BuildContext context) =>
              DeliveryOrdersMapPage(),
        },
        theme: ThemeData(
          primaryColor: MyColors.primaryColor,
          appBarTheme: AppBarTheme(elevation: 0),
          fontFamily: 'NimbusSans',
        ));
  }
}
