import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iris_delivery_app_stable/src/models/category.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/categories_providers.dart';
import 'package:iris_delivery_app_stable/src/provider/products_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/my_alert_dialog.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:iris_delivery_app_stable/src/models/product.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RestaurantProductsCreateController {

  BuildContext context;
  Function refresh;

  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  MoneyMaskedTextController priceController = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  CategoriesProviders _categoriesProvider = new CategoriesProviders();
  ProductsProviders _productsProviders = new ProductsProviders();
  User user;
  SharedPref sharedPref = new SharedPref();

  List<Category> categories = [];
  String idCategory;

  PickedFile pickedFile;
  File imageFile1;
  File imageFile2;
  File imageFile3;
  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    _productsProviders.init(context, user);
    getCategories();
  }

  void getCategories()async{
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  void createProduct() async {
    String name = nameController.text;
    String description = descriptionController.text;
    double price = priceController.numberValue;

    if (name.isEmpty || description.isEmpty || price == 0) {
      MyAlertDialog.show(context, 'Todos los campos son requeridos');
      return;
    }

    if(imageFile1 == null || imageFile2 == null || imageFile3 == null){
      MyAlertDialog.show(context, 'Debe seleccionar 3 imagenes');
      return;
    }

    if(idCategory == null){
      MyAlertDialog.show(context, 'Debe seleccionar una categoria');
      return;
    }
    Product product = new Product(
      name: name,
      description: description,
      price: price,
      idCategory: int.parse(idCategory),
    );

    List<File> images = [];
    images.add(imageFile1);
    images.add(imageFile2);
    images.add(imageFile3);


    _progressDialog.show(max: 100, msg: 'Espere un momento...');
    Stream stream = await _productsProviders.create(product, [imageFile1, imageFile2, imageFile3]);
    stream.listen((res) {
      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      MyAlertDialog.show(context, responseApi.message);

      if(responseApi.success){
        resetValues();
      }
      print('Response: $res');
    });
    print('Producto: ${product.toJson()}');
  }

  void resetValues(){
    nameController.text = '';
    descriptionController.text = '';
    priceController.text = '0.0';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory = null;

    refresh();
  }

  Future selectImage(ImageSource imageSource, int numberFile) async{
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if(pickedFile != null){
      if(numberFile == 1){
        imageFile1 = File(pickedFile.path);
      }
      else if(numberFile == 2){
        imageFile2 = File(pickedFile.path);
      }
      else if(numberFile == 3){
        imageFile3 = File(pickedFile.path);
      }
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(int numberFile){
    Widget galleryButton = ElevatedButton(
      onPressed: (){
        selectImage(ImageSource.gallery, numberFile);
      },
      child: Text('Galeria'),
    );

    Widget cameraButton = ElevatedButton(
      onPressed: (){
        selectImage(ImageSource.camera, numberFile);
      },
      child: Text('Camara'),
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context){
          return alertDialog;
        }
    );
  }
}