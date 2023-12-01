import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class RestaurantOrdersListController{
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Future init(BuildContext context){
    this.context = context;
  }

  void logout(){
    _sharedPref.logout(context);
  }

  void openDrawer(){
    key.currentState.openDrawer();

  }
}