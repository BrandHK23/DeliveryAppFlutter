import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/users_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/my_alert_dialog.dart';
import 'package:iris_delivery_app_stable/src/utils/my_snackbar.dart';

class RegisterController{
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  UsersProviders usersProviders = new UsersProviders();

  Future init(BuildContext context){
    this.context = context;
    usersProviders.init(context);
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

    User user = new User(
      email: email,
      name: name,
      lastname: lastname,
      phone: phone,
      password: password,
    );

    ResponseApi responseApi = await usersProviders.create(user);

    MySnackbar.show(context, responseApi.message);

    if(responseApi.success){
      Future.delayed(Duration(seconds:2), (){
        Navigator.pushReplacementNamed(context, 'login');
      });
    }

    print('ResponseApi: ${responseApi.toJson()}' );

    print('Email: $email');
    print('Name: $name');
    print('Lastname: $lastname');
    print('Phone: $phone');
    print('Password: $password');
    print('Confirm Password: $confirmPassword');
  }
}