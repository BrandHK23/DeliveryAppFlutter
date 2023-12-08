import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/users_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/my_alert_dialog.dart';
import 'package:iris_delivery_app_stable/src/utils/my_snackbar.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientUpdateController{
  BuildContext context;
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  UsersProviders usersProviders = new UsersProviders();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable = true;
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    usersProviders.init(context);
    _progressDialog = new ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read("user"));

    nameController.text = user.name;
    lastnameController.text = user.lastname;
    phoneController.text = user.phone;
    refresh();
  }

  Future<void> update() async {
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String phone = phoneController.text.trim();


    if(imageFile == null){
      MyAlertDialog.show(context, 'Seleccione una imagen');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Espere un momento...');
    isEnable = false;

    User myUser = new User(
      id: user.id,
      name: name,
      lastname: lastname,
      phone: phone,
    );

    Stream stream = await usersProviders.update(myUser, imageFile);
    stream.listen((res) async {
      _progressDialog.close();

      // ResponseApi responseApi = await usersProviders.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      Fluttertoast.showToast(msg: responseApi.message);


      if(responseApi.success){
        user = await usersProviders.getById(user.id); // Obtener usuario de la BD
        _sharedPref.save("user", user.toJson()); // Guardar usuario en el SharedPref
        Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
      }
      else{
        isEnable = true;
      }
    });

    print('Name: $name');
    print('Lastname: $lastname');
    print('Phone: $phone');
  }

  Future selectImage(ImageSource imageSource) async{
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if(pickedFile != null){
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(){
    Widget galleryButton = ElevatedButton(
      onPressed: (){
        selectImage(ImageSource.gallery);
      },
      child: Text('Galeria'),
    );

    Widget cameraButton = ElevatedButton(
      onPressed: (){
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
        builder: (BuildContext context){
          return alertDialog;
        }
    );
  }
}