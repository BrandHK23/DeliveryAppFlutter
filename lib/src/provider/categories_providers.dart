import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iris_delivery_app_stable/src/api/environment.dart';
import 'package:iris_delivery_app_stable/src/models/category.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class CategoriesProviders {
  String _url = Environment.API_DELIVERY;
  String _api = '/api/categories';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Category>> getAll() async {
    try {
      Uri url = Uri.http(_url, '$_api/getAll');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      final jsonData = json.decode(res.body);
      if (jsonData['success'] == true) {
        List<dynamic> categoriesData = jsonData['data'];
        List<Category> categories =
            categoriesData.map((json) => Category.fromJson(json)).toList();
        return categories;
      } else {
        Fluttertoast.showToast(msg: jsonData['message']);
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Buscar categoría por negocio
  Future<List<Category>> getByBusiness(String idBusiness) async {
    try {
      Uri url = Uri.http(_url, '$_api/getByBusiness/$idBusiness');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      if (res.statusCode == 404) {
        Fluttertoast.showToast(msg: 'Categorías no encontradas');
      }

      final jsonData = json.decode(res.body);
      if (jsonData['success'] == true) {
        List<dynamic> categoriesData = jsonData['data'];
        List<Category> categories =
            categoriesData.map((json) => Category.fromJson(json)).toList();
        return categories;
      } else {
        Fluttertoast.showToast(msg: jsonData['message']);
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<ResponseApi> create(Category category) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(category);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.post(url, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
