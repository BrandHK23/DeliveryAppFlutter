import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/business.dart';
import 'package:iris_delivery_app_stable/src/models/category.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/categories_providers.dart';
import 'package:iris_delivery_app_stable/src/provider/products_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class RestaurantProductMenuController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  User user;
  Business business;

  Function refresh;

  ProductsProviders _productsProviders = new ProductsProviders();
  CategoriesProviders _categoriesProviders = new CategoriesProviders();

  List<Category> categories = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read("user"));

    await loadBusinessData(); // Asegúrate de cargar los datos del negocio aquí

    _categoriesProviders.init(context, user);
    _productsProviders.init(context, user);
    getCategories();
    refresh();
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

  Future<List<Product>> getProducts(
      String idCategory, String idBusiness) async {
    return await _productsProviders.getByCategoryAndBusiness(
        idCategory, idBusiness);
  }

  void getCategories() async {
    categories = await _categoriesProviders.getByBusiness(business.idBusiness);
    if (business.idBusiness == null) {
      print("Business id is null");
    }
    refresh();
  }

  void logout() {
    _sharedPref.logout(context, user.id);
  }

  void openDrawer() {
    print("Open drawer");
    print("Business data loaded: ${this.business.toJson()}");
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

  void goToOrders() {
    Navigator.pushNamed(context, 'restaurant/orders/list');
  }
}
