import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iris_delivery_app_stable/src/api/environment.dart';
import 'package:iris_delivery_app_stable/src/models/business_address.dart';
import 'package:iris_delivery_app_stable/src/models/response_api.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class BusinessAddressProviders {
  String _url = Environment.API_DELIVERY;
  String _api = '/api/businessAddress';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

/*
  Future<List<Address>> getByUser(String idUser) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByUser/${idUser}');
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
        List<dynamic> addressData = jsonData['data'];
        List<Address> address =
            addressData.map((json) => Address.fromJson(json)).toList();
        return address;
      } else {
        Fluttertoast.showToast(msg: jsonData['message']);
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
*/

  Future<ResponseApi> create(BusinessAddress businessAddress) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(businessAddress);
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
