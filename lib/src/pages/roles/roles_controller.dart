import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class RolesController{
  BuildContext context;
  Function refresh;

  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    //Obtener el usuario de sesion
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
  }

  void goToPage(String route){
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}