import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/users_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/my_alert_dialog.dart';
import 'package:iris_delivery_app_stable/src/utils/my_snackbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController{
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  UsersProviders usersProviders = new UsersProviders();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable = true;

  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
    usersProviders.init(context);
    _progressDialog = new ProgressDialog(context: context);
  }

  Future<void> register() async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if(email.isEmpty || name.isEmpty || lastname.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      MyAlertDialog.show(context, 'Todos los campos son obligatorios');
      return;
    }

    if(password != confirmPassword){
      MyAlertDialog.show(context, 'Las contraseñas no coinciden');
      return;
    }

    if(password.length < 6){
      MyAlertDialog.show(context, 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if(imageFile == null){
      MyAlertDialog.show(context, 'Seleccione una imagen');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Espere un momento...');
    isEnable = false;

    User user = new User(
      email: email,
      name: name,
      lastname: lastname,
      phone: phone,
      password: password,
    );

    Stream stream = await usersProviders.createWithImage(user, imageFile);
    stream.listen((res){
      _progressDialog.close();

      // ResponseApi responseApi = await usersProviders.create(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      print('ResponseApi: ${responseApi.toJson()}' );
      MySnackbar.show(context, responseApi.message);

      if(responseApi.success){
        Future.delayed(Duration(seconds:2), (){
          Navigator.pushReplacementNamed(context, 'login');
        });
      }
      else{
        isEnable = true;
      }
    });

    print('Email: $email');
    print('Name: $name');
    print('Lastname: $lastname');
    print('Phone: $phone');
    print('Password: $password');
    print('Confirm Password: $confirmPassword');
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