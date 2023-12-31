import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class ClientProductsDetailController {
  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  SharedPref _sharedPref = new SharedPref();

  List<Product> selectedProducts = [];

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product.price;

    //_sharedPref.remove('order');

    selectedProducts =
        Product.fromJsonList(await _sharedPref.read('order')).toList;

    selectedProducts.forEach((p) {
      print('Productos seleccionados: ${p.toJson()}');
    });

    refresh();
  }

  void addToBag() {
    int index = selectedProducts.indexWhere((p) => p.id == product.id);

    if (index == -1) {
      if (product.quantity == null) {
        product.quantity = 1;
      }
      selectedProducts.add(product);
    } else {
      selectedProducts[index].quantity = counter;
    }

    _sharedPref.save('order', selectedProducts);
    Fluttertoast.showToast(msg: 'Producto agregado al carrito');
  }

  void addItem() {
    counter++;
    productPrice = product.price * counter;
    product.quantity = counter;
    refresh();
  }

  void removeItem() {
    if (counter > 1) {
      counter--;
      productPrice = product.price * counter;
      product.quantity = counter;
      refresh();
    }
  }
}
