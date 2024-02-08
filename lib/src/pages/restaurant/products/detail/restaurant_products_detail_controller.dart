import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/provider/products_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class RestaurantProductsDetailController {
  BuildContext context;
  Function refresh;

  Product product;

  double productPrice;

  TextEditingController nameController;
  TextEditingController descriptionController;
  TextEditingController priceController;

  SharedPref _sharedPref = new SharedPref();
  ProductsProviders _productsProvider = new ProductsProviders();

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product.price;

    nameController = new TextEditingController(text: product.name);
    descriptionController =
        new TextEditingController(text: product.description);
    priceController = new TextEditingController(text: product.price.toString());

    refresh();
  }

  void updateProductName(
      String newName, String newDescription, double newPrice) {
    product.name = newName;
    product.description = newDescription;
    product.price = newPrice;

    refresh();
  }
}
