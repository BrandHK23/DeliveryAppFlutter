import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/business.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/business_providers.dart';
import 'package:iris_delivery_app_stable/src/provider/products_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class ClientRestaurantListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;
  Function refresh;
  ProductsProviders _productsProviders = new ProductsProviders();
  List<Business> business = [];

  Timer searchOnStoppedTyping;
  String productName = "";

  BusinessProviders _businessProviders = new BusinessProviders();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read("user"));
    _businessProviders.init(context, user);
    _productsProviders.init(context, user);
    business = await getBusinessAvailable();
    refresh();
  }

  Future<List<Product>> getProducts(
      String idCategory, String productName) async {
    if (productName.isEmpty) {
      return await _productsProviders.getByCategory(idCategory);
    } else {
      return await _productsProviders.getByCategoryAndProductName(
          idCategory, productName);
    }
  }

  Future<List<Business>> getBusinessAvailable() async {
    return await _businessProviders.getAllAvailable();
  }

  void onChangeText(String text) {
    Duration duration = Duration(milliseconds: 500);

    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping.cancel();
      refresh();
    }

    searchOnStoppedTyping = new Timer(duration, () {
      productName = text;
      refresh();
      print("Stopped typing $text");
    });
  }

  /*
  void openBottomSheet(Business business) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientRestaurantDetailPage(
              business: business,
            ));
  }
   */

  void logout() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    // Debugging
    print(user.userHasBusiness);
    print(user.sessionToken);
    print(user.email);
    print(user.roles[0].name);
    print(user.roles[0].name == 'RESTAURANTE');
    print(user.name);
    key.currentState.openDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void goToUpdatePage() {
    Navigator.pushNamed(context, 'client/update');
  }

  void goToOrdersList() {
    Navigator.pushNamed(context, 'client/orders/list');
  }

  void goToOrdersCreatePage() {
    Navigator.pushNamed(context, 'client/orders/create');
  }
}
