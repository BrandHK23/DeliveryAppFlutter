import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iris_delivery_app_stable/src/api/environment.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:http/http.dart' as http;


class UsersProviders{
  String _url = Environment.API_DELIVERY;
  String _api = '/api/users';

  BuildContext context;

  Future init(BuildContext context) {
    this.context = context;
  }

  Future <ResponseApi> create(User user) async{

    try{
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(user);
      Map<String, String> headers = {
        'Content-Type': 'application/json'
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;

    }catch(e){
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> login(String email, String password) async {
    try {
      Uri url = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({
        'email': email,
        'password': password,
      });
      Map<String, String> headers = {
        'Content-Type': 'application/json'
      };
      final res = await http.post(url, headers: headers, body: bodyParams);

      // Imprimir la respuesta para depuración
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');

      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }
}