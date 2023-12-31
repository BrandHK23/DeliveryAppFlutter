import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:iris_delivery_app_stable/src/api/environment.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_document_type.dart';
import 'package:iris_delivery_app_stable/src/models/mercado_pago_payment_method_installments.dart';
import 'package:iris_delivery_app_stable/src/models/order.dart';
import 'package:iris_delivery_app_stable/src/models/user.dart';
import 'package:iris_delivery_app_stable/src/utils/shared_pref.dart';

class MercadoPagoProvider {
  String _urlMercadoPago = 'api.mercadopago.com';
  String _url = Environment.API_DELIVERY;
  final _mercadoPagoCredentials = Environment.mercadoPagoCredentials;

  BuildContext context;
  User user;

  Future init(BuildContext context, User user) {
    this.context = context;
    this.user = user;
  }

  Future<List<MercadoPagoDocumentType>> getIdentificationType() async {
    try {
      final url = Uri.https(_urlMercadoPago, '/v1/identification_types',
          {'access_token': _mercadoPagoCredentials.accessToken});

      final res = await http.get(url);
      final data = json.decode(res.body);
      final result = new MercadoPagoDocumentType.fromJsonList(data);
      return result.documentTypeList;
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Response> createCardToken({
    String cvv,
    String expirationMonth,
    String expirationYear,
    String cardNumber,
    String cardHolderName,
  }) async {
    try {
      final url = Uri.https(_urlMercadoPago, '/v1/card_tokens',
          {'public_key': _mercadoPagoCredentials.publicKey});
      final body = {
        'security_code': cvv,
        'expiration_month': expirationMonth,
        'expiration_year': expirationYear,
        'card_number': cardNumber,
        'cardholder': {
          'name': cardHolderName,
        },
      };

      final res = await http.post(url, body: json.encode(body));
      return res;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<http.Response> createPayment({
    @required String cardId,
    @required double transactionAmount,
    @required int installments,
    @required String paymentMethodId,
    @required String paymentTypeId,
    @required String issuerId,
    @required String emailCustomer,
    @required String cardToken,
    @required Order order,
  }) async {
    try {
      final url = Uri.http(_url, '/api/payments/createPay', {
        'public_key': _mercadoPagoCredentials.publicKey,
      });
      Map<String, dynamic> body = {
        'order': order,
        'card_id': cardId,
        'description': 'Iris Delivery App',
        'transaction_amount': transactionAmount,
        'installments': installments,
        'payment_method_id': paymentMethodId,
        'payment_type_id': paymentTypeId,
        'token': cardToken,
        'issuer_id': issuerId,
        'payer': {
          'email': emailCustomer,
        },
      };

      String bodyParams = json.encode(body);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': user.sessionToken
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context, user.id);
      }

      return res;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<MercadoPagoPaymentMethodInstallments> getInstallments(
      String bin, double amount) async {
    try {
      final url =
          Uri.https(_urlMercadoPago, '/v1/payment_methods/installments', {
        'access_token': _mercadoPagoCredentials.accessToken,
        'bin': bin,
        'amount': amount.toStringAsFixed(2),
      });

      final res = await http.get(url);
      final data = json.decode(res.body);
      print('INSTALLMENTS DATA: $data');

      if (data is Map && data.containsKey('error')) {
        // Manejar el error aquí.
        print('Error en la solicitud de cuotas: ${data['message']}');
        return null;
      } else {
        final result =
            new MercadoPagoPaymentMethodInstallments.fromJsonList(data);
        return result.installmentList.first;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
