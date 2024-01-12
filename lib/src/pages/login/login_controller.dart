import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/business.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/business_providers.dart';
import 'package:iris_delivery_app_stable/src/provider/users_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class LoginController {
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UsersProviders usersProviders = new UsersProviders();
  BusinessProviders businessProviders = new BusinessProviders();
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context) async {
    this.context = context;
    await usersProviders.init(context);

    User user = User.fromJson(await _sharedPref.read('user') ?? {});

    if (user?.sessionToken != null) {
      print('User: ${user.toJson()}');

      if (user.roles.length > 1) {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
      }
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    ResponseApi responseApi = await usersProviders.login(email, password);

    print('Respuesta objeto: $responseApi');
    print('Respuesta: ${responseApi.toJson()}');

    if (responseApi.success) {
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());

      print('User: ${user.toJson()}');

      // Guardar el negocio en el dispositivo
      if (user.userHasBusiness) {
        ResponseApi businessResponse =
            await businessProviders.getBusinessByUserId(user.id);
        if (businessResponse.success && businessResponse.data != null) {
          Business business = Business.fromJson(businessResponse.data);
          _sharedPref.save('business', json.encode(business.toJson()));
          print('Respuesta: ${businessResponse.toJson()}');
          print('Business: ${business.toJson()}');
        } else {
          print('No se encontraron datos del negocio');
        }
      }

      if (user.roles.length > 1) {
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, user.roles[0].route, (route) => false);
      }
    } else {
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
