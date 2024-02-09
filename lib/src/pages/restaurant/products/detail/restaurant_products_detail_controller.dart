import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/products_providers.dart';
import 'package:iris_delivery_app_stable/src/provider/users_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RestaurantProductsDetailController {
  BuildContext context;
  Function refresh;
  ProgressDialog _progressDialog;

  Product product;
  User user;

  double productPrice;

  bool nameModified = false;
  bool descriptionModified = false;
  bool priceModified = false;

  TextEditingController nameController;
  TextEditingController descriptionController;
  TextEditingController priceController;

  UsersProviders usersProviders = new UsersProviders();
  SharedPref _sharedPref = new SharedPref();
  ProductsProviders _productsProvider = new ProductsProviders();

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product.price;
    _progressDialog = new ProgressDialog(context: context);

    // Asegúrate de que esta línea obtenga correctamente el usuario en sesión
    var userJson = await _sharedPref.read("user");
    if (userJson != null) {
      user = User.fromJson(userJson);
      // Inicializa el ProductsProvider con el usuario actual
      _productsProvider.init(context, user);
    } else {
      print("Error: No se ha encontrado el usuario en sesión.");
      // Considera manejar este error adecuadamente, tal vez redirigiendo al login
    }

    nameController = new TextEditingController(text: product.name);
    descriptionController =
        new TextEditingController(text: product.description);
    priceController = new TextEditingController(text: product.price.toString());

    refresh();
  }

  void saveChanges() async {
    _progressDialog.show(max: 100, msg: 'Guardando cambios...');

    // Verifica si hubo cambios antes de proceder
    if (nameModified || descriptionModified || priceModified) {
      product.name = nameModified ? nameController.text : product.name;
      product.description = descriptionModified
          ? descriptionController.text
          : product.description;
      product.price = priceModified
          ? double.tryParse(priceController.text) ?? product.price
          : product.price;

      bool success = await _productsProvider.updateProduct(product);
      _progressDialog.close(); // Cierra el diálogo de progreso

      if (success) {
        print("Producto actualizado con éxito.");
        // Restablece los indicadores de modificación una vez que la actualización es exitosa
        nameModified = descriptionModified = priceModified = false;
        Fluttertoast.showToast(msg: 'Producto actualizado con éxito');
        refresh(); // Actualiza la UI
      } else {
        print("Error al actualizar el producto.");
        Fluttertoast.showToast(msg: 'Error al actualizar el producto');
      }
    } else {
      _progressDialog.close();
      print("No se detectaron cambios.");
      Fluttertoast.showToast(msg: 'No se detectaron cambios');
    }

    print("Session token: ${user.sessionToken}");
  }

  void saveLocalChanges() {
    // Actualización directa desde los controladores
    String newName = nameController.text;
    String newDescription = descriptionController.text;
    double newPrice = double.tryParse(priceController.text);

    // Verificación para actualizar solo si hay cambios
    if (product.name != newName) {
      product.name = newName;
      nameModified = true;
    }
    if (product.description != newDescription) {
      product.description = newDescription;
      descriptionModified = true;
    }
    if (product.price != newPrice) {
      product.price = newPrice;
      priceModified = true;
    }

    print('New name: ${product.name}');
    print('New Description: ${product.description}');
    print('New Price: ${product.price}');

    // No restablezcas los indicadores aquí, hazlo después de una actualización exitosa en saveChanges()
  }
}
