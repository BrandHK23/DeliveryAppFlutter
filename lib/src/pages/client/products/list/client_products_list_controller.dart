import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class ClientProductListController{
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context){
    this.context = context;
  }

  logout(){
    _sharedPref.logout(context);
  }
}