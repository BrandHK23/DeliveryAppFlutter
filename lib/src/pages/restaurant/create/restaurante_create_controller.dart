import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iris_delivery_app_stable/src/models/business.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/provider/business_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/my_alert_dialog.dart';
import 'package:iris_delivery_app_stable/src/utils/my_snackbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RestaurantCreateController {
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController idNegocioController = new TextEditingController();

  BusinessProviders businessProvider = new BusinessProviders();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable = true;

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    businessProvider.init(context);
    _progressDialog = new ProgressDialog(context: context);
  }

  Future<void> register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String idNegocio = idNegocioController.text.trim();

    if (email.isEmpty || name.isEmpty || phone.isEmpty || idNegocio.isEmpty) {
      MyAlertDialog.show(context, 'Todos los campos son obligatorios');
      return;
    }

    if (imageFile == null) {
      MyAlertDialog.show(context, 'Seleccione una imagen');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Espere un momento...');
    isEnable = false;

    Business business = new Business(
      businessName: name,
      email: email,
      phone: phone,
      isActive: false,
      isAvailable: false,
      idUser: idNegocio,
    );

    Stream stream = await businessProvider.createWithImage(business, imageFile);
    stream.listen((res) async {
      print('Server Response: $res');
      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      print('ResponseApi: ${responseApi.toJson()}');
      MySnackbar.show(context, responseApi.message);

      if (responseApi.success) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, 'restaurant/address/create');
          //Navigator.pushReplacementNamed(context, );
        });
      } else {
        isEnable = true;
      }
    });

    print('Business data to send: ${business.toJson()}');
    print('Name: $name');
    print('Email: $email');
    print('Phone: $phone');
    print('IdNegocio: $idNegocio');
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        selectImage(ImageSource.gallery);
      },
      child: Text('Galeria'),
    );

    Widget cameraButton = ElevatedButton(
      onPressed: () {
        selectImage(ImageSource.camera);
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
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
