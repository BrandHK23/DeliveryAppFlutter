import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/provider/users_providers.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class RolesController {
  BuildContext context;
  Function refresh;

  User user;
  SharedPref _sharedPref = new SharedPref();
  UsersProviders usersProvider = new UsersProviders();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    //Obtener el usuario de sesion
    user = User.fromJson(await _sharedPref.read('user'));

    refresh();
  }

  void goToPage(String route) {
    print('Not Restaurant');
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  void goToPages(String roleName, String route) async {
    print('Rol: $roleName, Ruta: $route');
    print('User has business: ${user.userHasBusiness}');
    print('User: ${user.id}');
    print('User: ${user.sessionToken}');

    if (roleName == 'RESTAURANTE') {
      bool hasBusiness = user.userHasBusiness;
      if (hasBusiness) {
        print('User has business: ${user.userHasBusiness}');
        Navigator.pushNamedAndRemoveUntil(
            context, 'restaurant/orders/list', (route) => false);
      } else {
        print('User has business: ${user.userHasBusiness}');
        Navigator.pushNamedAndRemoveUntil(
            context, 'restaurant/create', (route) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }
}
