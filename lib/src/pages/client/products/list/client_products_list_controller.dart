import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/category.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/pages/client/products/detail/client_product_detail_page.dart';
import 'package:iris_delivery_app_stable/src/provider/categories_providers.dart';
import 'package:iris_delivery_app_stable/src/provider/products_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  User user;
  Function refresh;
  ProductsProviders _productsProviders = new ProductsProviders();
  List<Category> categories = [];

  Timer searchOnStoppedTyping;
  String productName = "";

  CategoriesProviders _categoriesProviders = new CategoriesProviders();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read("user"));
    _categoriesProviders.init(context, user);
    _productsProviders.init(context, user);
    getCategories();
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

  void onChangeText(String text) {
    Duration duration = Duration(milliseconds: 500);

    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping.cancel();
      refresh();
    }

    searchOnStoppedTyping = new Timer(duration, () {
      productName = text;
      refresh();
      print("Stopped typing ${text}");
    });
  }

  void getCategories() async {
    categories = await _categoriesProviders.getAll();
    refresh();
  }

  void openBottomSheet(Product product) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientProductDetailPage(
              product: product,
            ));
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
