import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/users_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/my_alert_dialog.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class LoginController{
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UsersProviders usersProviders = new UsersProviders();
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context) async{
    this.context = context;
    await usersProviders.init(context);

    User user = User.fromJson(await _sharedPref.read('user') ?? {});

    if(user?.sessionToken != null){
      Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
    }
  }

  void goToRegisterPage(){
    Navigator.pushNamed(context, 'register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    ResponseApi responseApi = await usersProviders.login(email, password);

    print('Respuesta objeto: ${responseApi}');
    print('Respuesta: ${responseApi.toJson()}');

    if(responseApi.success){
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());
      Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);

    }else{
      print('Login fallido. ${responseApi.message}');
    }

    if (responseApi != null) {
      print('ResponseApi: ${responseApi.toJson()}');
    } else {
      print('Login fallido. La respuesta es null.');
    }

    print('Email: $email');
    print('Password: $password');
  }


}