import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iris_delivery_app_stable/src/api/environment.dart';
import 'package:iris_delivery_app_stable/src/models/order.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class OrdersProviders {
  String _url = Environment.API_DELIVERY;
  String _api = '/api/order';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Order>> getByStatus(String status) async {
    if (sessionUser == null || sessionUser.sessionToken == null) {
      Fluttertoast.showToast(msg: 'No hay usuario de sesión');
      return [];
    }

    try {
      Uri url = Uri.http(_url, '$_api/findByStatus/$status');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context, sessionUser.id);
        return [];
      }

      final responseBody = json.decode(res.body);

      if (responseBody['data'] is List) {
        // Extrae la lista de órdenes del campo 'data'
        List<dynamic> ordersData = responseBody['data'];
        Order order = Order.fromJsonList(ordersData);
        return order.toList;
      } else {
        Fluttertoast.showToast(
            msg: 'La respuesta no contiene una lista válida');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'Ocurrió un error al obtener las órdenes');
      return [];
    }
  }

  Future<List<Order>> getByDeliveryAndStatus(
      String idDelivery, String status) async {
    if (sessionUser == null || sessionUser.sessionToken == null) {
      Fluttertoast.showToast(msg: 'No hay usuario de sesión');
      return [];
    }

    try {
      Uri url =
          Uri.http(_url, '$_api/findByDeliveryAndStatus/$idDelivery/$status');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context, sessionUser.id);
        return [];
      }

      final responseBody = json.decode(res.body);

      if (responseBody['data'] is List) {
        // Extrae la lista de órdenes del campo 'data'
        List<dynamic> ordersData = responseBody['data'];
        Order order = Order.fromJsonList(ordersData);
        return order.toList;
      } else {
        Fluttertoast.showToast(
            msg: 'La respuesta no contiene una lista válida');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'Ocurrió un error al obtener las órdenes');
      return [];
    }
  }

  Future<ResponseApi> create(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(order);
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

  Future<ResponseApi> updateToPrepared(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateToPrepared');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);

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

  Future<ResponseApi> updateToOnTheWay(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateToOnTheWay');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);

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
